from dataclasses import dataclass, field
from typing import Dict, List, Optional, TypedDict, Tuple

import requests
from bs4 import BeautifulSoup, Tag
from helpers import (convert_empty_vals_to_none, parse_key_signature,
                     standardize_dict_keys)
from movements import Movement, parse_movements


@dataclass
class Piece:
    work_name: str
    composer_name: str
    catalogue_desc_str: Optional[str] = None
    catalogue_type: Optional[str] = None  # op, bmv, etc
    catalogue_number: Optional[int] = None
    catalogue_number_secondary: Optional[int] = None
    catalogue_id: Optional[int] = None
    composition_year: Optional[int] = None
    composition_year_string: Optional[str] = None
    key_signature: Optional[str] = None
    movements: List[Movement] = field(default_factory=list)  # change to sub-piece
    sub_piece_type: Optional[str] = None
    sub_piece_count: Optional[int] = None
    instrumentation: Optional[List[str]] = field(default_factory=list)
    nickname: Optional[str] = None
    piece_style: Optional[str] = None
    imslp_url: Optional[str] = None
    wikipedia_url: Optional[str] = None

def parse_movements_section(td_text: str) -> Tuple[Optional[int], Optional[str]]:
    """
    Parse the Movements/Sections text to extract count and type.
    
    Args:
        td_text: The text content from the table cell containing movements/sections info
        
    Returns:
        Tuple containing:
        - count: The number of movements/sections (largest number if multiple found)
        - type: The type of sections (e.g. 'movements', 'preludes', 'variations')
    """
    parsed_data = td_text.split()
    numbers = []
    current_type = None
    
    # Iterate through words to find numbers and potential types
    for i, word in enumerate(parsed_data):
        # Try to parse number
        try:
            num = int(word)
            numbers.append(num)
            # Look ahead for type if there's a next word
            if i + 1 < len(parsed_data):
                next_word = parsed_data[i + 1].lower().rstrip(',:')
                if next_word != 'or':  # Skip if next word is "or"
                    current_type = next_word
        except ValueError:
            # If word is "or", continue looking
            if word.lower() == 'or':
                continue
            # If we already found numbers but no type yet, this might be the type
            elif numbers and not current_type:
                current_type = word.lower().rstrip(',:')
    
    count = max(numbers) if numbers else None
    return count, current_type


def create_piece(data: Optional[Tag] = None, url: Optional[str] = None) -> Optional[Piece]:
    if not data and not url:
        raise ValueError("No data or url argument found")

    if url:
        response = requests.get(url, timeout=10)
        data = BeautifulSoup(response.text, "html.parser")

    if not data:
        raise ValueError("Beautiful soup object could not be initialized")

    general_info_div = data.find("div", class_="wi_body")

    metadata = {}
    wiki_url = None
    if isinstance(general_info_div, Tag):
        for row in general_info_div.find_all("tr"):
            th = row.find("th")
            td = row.find("td")
            if th.get_text(strip=True) == "External Links" and td:
                for link in td.find_all("a", href=True):
                    href = link["href"]
                    if "wikipedia" in href:
                        wiki_url = href

            if th and td:
                metadata[th.get_text(strip=True)] = td.get_text(strip=True)

    meta_attributes = parse_metadata(metadata)
    movements = parse_movements(data)
    if meta_attributes:
        piece = Piece(
            work_name=meta_attributes["work_title"],
            composer_name=meta_attributes["composer_name"],
            movements=movements,
            sub_piece_type=meta_attributes["sub_piece_type"],
            sub_piece_count=meta_attributes["sub_piece_count"],
            composition_year_string=meta_attributes["composition_year_string"],
            composition_year=meta_attributes["composition_year"],
            catalogue_type=meta_attributes["catalogue_type"],
            catalogue_number=meta_attributes["catalogue_number"],
            catalogue_number_secondary=meta_attributes["catalogue_number_secondary"],
            key_signature=meta_attributes["key_signature"],
            instrumentation=meta_attributes["instrumentation"],
            catalogue_desc_str=meta_attributes["opus_catalogue_number_op_cat_no"],
            nickname=meta_attributes["nickname"],
            piece_style=meta_attributes["piece_style"],
            wikipedia_url=wiki_url,
        )

        if url:
            piece.imslp_url = url

        top_header = data.find("div", class_="wp_header")

        if isinstance(top_header, Tag):
            for row in top_header.find_all("tr"):
                th = row.find("th")
                td = row.find("td")
                if th and td:
                    th_text = th.get_text(strip=True)
                    if "Movements/Sections" in th_text:
                        td_text = td.get_text(strip=True)
                        count, section_type = parse_movements_section(td_text)
                        piece.sub_piece_count = count
                        piece.sub_piece_type = section_type
                            
        return piece


class PieceMetadata(TypedDict):
    work_title: str
    opus_catalogue_number_op_cat_no: Optional[str]
    catalogue_type: Optional[str]
    composer_name: str
    catalogue_number: Optional[int]
    catalogue_number_secondary: Optional[int]
    key_signature: Optional[str]
    composition_year_string: Optional[str]
    composition_year: Optional[int]
    instrumentation: Optional[List[str]]
    sub_piece_type: Optional[str]
    sub_piece_count: Optional[int]
    nickname: Optional[str]
    piece_style: Optional[str]

def parse_catalogue_number(opus_value: str) -> tuple[str | None, int | None, int | None]:
    """
    Parse a catalogue number string into its components.
    Prioritizes BWV numbers for Bach works and H numbers when present anywhere in the string.
    
    Args:
        opus_value: The catalogue number string (e.g. "BWV 1234", "K.466", "Op. 27 No. 2", "Œuvre 28 ; H 137")
        
    Returns:
        tuple containing:
        - catalogue_type (str or None): The type of catalogue (e.g. "bwv", "h", "k", "op")
        - catalogue_number (int or None): The primary number
        - catalogue_number_secondary (int or None): The secondary number (e.g. the number after "No.")
    """
    # Normalize string - remove parentheses and brackets, convert to lowercase
    normalized_value = opus_value.lower().replace("[", "").replace("]", "").replace("(", "").replace(")", "")
    
    # First check for BWV anywhere in the string
    if "bwv" in normalized_value:
        parts = normalized_value.split("bwv")
        if len(parts) > 1:
            # Take the part after "bwv" and try to extract the number
            bwv_part = parts[1].split()[0] if parts[1].split() else ""
            try:
                bwv_number = int(''.join(c for c in bwv_part if c.isdigit()))
                return "bwv", bwv_number, None
            except ValueError:
                pass
    
    # Check for H catalogue numbers anywhere in the string
    if " h " in normalized_value or ";h" in normalized_value or normalized_value.startswith("h"):
        # Split on common delimiters and look for the H number
        parts = normalized_value.replace(";", " ").replace(",", " ").replace(".", " ").split()
        for i, part in enumerate(parts):
            if part == "h" and i + 1 < len(parts):
                try:
                    h_number = int(''.join(c for c in parts[i + 1] if c.isdigit()))
                    return "h", h_number, None
                except ValueError:
                    pass
    
    # Handle special cases with numbers in catalogue types
    special_prefixes = ["k2", "k3", "k6", "k9", "k046", "k030", "k008"]
    
    # Split on common delimiters
    split_catalogue_string = normalized_value.replace(".", " ").replace(";", " ").replace(",", " ").split()
    
    if not split_catalogue_string:
        return None, None, None
        
    # Try to identify catalogue type
    catalogue_type = None
    catalogue_number = None
    catalogue_number_secondary = None
    
    # First check for special prefixes
    for prefix in special_prefixes:
        if normalized_value.startswith(prefix):
            catalogue_type = prefix
            remaining = normalized_value[len(prefix):].strip()
            try:
                catalogue_number = int(''.join(c for c in remaining if c.isdigit()))
            except ValueError:
                catalogue_number = None
            break
    
    # If no special prefix found, try standard parsing
    if not catalogue_type:
        potential_type = split_catalogue_string[0]
        
        # Remove any trailing numbers from the type
        catalogue_type = ''.join(c for c in potential_type if not c.isdigit())
        
        # Try to extract number from the next part if it exists
        if len(split_catalogue_string) > 1:
            try:
                number_part = split_catalogue_string[1]
                catalogue_number = int(''.join(c for c in number_part if c.isdigit()))
            except (ValueError, IndexError):
                catalogue_number = None
    
    # Handle secondary numbers (after "No" or similar indicators)
    secondary_indicators = ["no", "no.", "number", "nr", "nr.", "#"]
    for i, part in enumerate(split_catalogue_string):
        if part.lower() in secondary_indicators and i + 1 < len(split_catalogue_string):
            try:
                catalogue_number_secondary = int(
                    ''.join(c for c in split_catalogue_string[i + 1] if c.isdigit())
                )
            except ValueError:
                catalogue_number_secondary = None
            break
            
    return catalogue_type, catalogue_number, catalogue_number_secondary

def parse_metadata(data: Dict[str, str]) -> Optional[PieceMetadata]:
    """
    Parse and standardize metadata from the input dictionary with data from general info
    table.

    Args:
        data: Dictionary containing raw metadata with string keys and values

    Returns:
        PieceMetadata: Processed metadata with standardized keys and proper types

    Raises:
        ValueError: If metadata dictionary is empty or work_title is missing
    """
    # Mapping for renaming keys
    rename_map = {
        "key": "key_signature",
        "year_date_of_composition_y_d_of_comp": "composition_year_string",
        "composer": "composer",
    }

    # Standardize dictionary: Convert keys to snake_case and replace empty strings with None
    metadata_dict = convert_empty_vals_to_none(data)
    metadata_dict = standardize_dict_keys(metadata_dict)

    if not metadata_dict:
        return

    # Initialize the processed metadata with default values
    processed_metadata: PieceMetadata = {
        "work_title": metadata_dict.get("work_title", ""),
        "opus_catalogue_number_op_cat_no": None,
        "sub_piece_type": None,
        "sub_piece_count": None,
        "instrumentation": None,
        "composition_year_string": None,
        "composition_year": None,
        "catalogue_type": None,
        "catalogue_number": None,
        "catalogue_number_secondary": None,
        "key_signature": None,
        "nickname": metadata_dict.get("alternative_title"),
        "composer_name": metadata_dict.get("composer", ""),
        "piece_style": None,
    }

    # Handle key renaming
    for old_key, new_key in rename_map.items():
        if old_key in metadata_dict:
            value = metadata_dict.pop(old_key)
            metadata_dict[new_key] = value
            if new_key in processed_metadata:  # Only update if it's a field we care about
                processed_metadata[new_key] = value

    # Parse catalogue information
    if opus_value := metadata_dict.get("opus_catalogue_number_op_cat_no"):
        processed_metadata["opus_catalogue_number_op_cat_no"] = opus_value
        cat_type, cat_num, cat_num_secondary = parse_catalogue_number(opus_value)
        processed_metadata["catalogue_type"] = cat_type
        processed_metadata["catalogue_number"] = cat_num
        processed_metadata["catalogue_number_secondary"] = cat_num_secondary

    if key_sig := metadata_dict.get("key_signature"):
        parsed_key = parse_key_signature(key_sig)
        processed_metadata["key_signature"] = parsed_key
        metadata_dict.pop("key_signature")

    if comp_year := metadata_dict.get("composition_year_string"):
        processed_metadata["composition_year_string"] = comp_year
        processed_metadata["composition_year"] = (
            int(comp_year[:4]) if comp_year and comp_year[:4].isdigit() else None
        )

    if instrumentation := metadata_dict.get("instrumentation"):
        if "and" in instrumentation:
            # Store as a list in the dictionary
            processed_metadata["instrumentation"] = [
                item.strip() for item in instrumentation.split("and")
            ]
        else:
            processed_metadata["instrumentation"] = (
                [instr.strip() for instr in instrumentation.split(",")]
                if "," in instrumentation
                else [instrumentation.strip()]
            )

    if piece_style := metadata_dict.get("piece_style"):
        processed_metadata["piece_style"] = piece_style.lower()

    if work_title := metadata_dict.get("work_title"):
        if " in " in work_title:
            work_title = work_title.split(" in ", 1)[0]
        processed_metadata["work_title"] = work_title

    # Ensure work_title is present
    if not processed_metadata["work_title"]:
        raise ValueError("work_title is required but not found in metadata")

    return processed_metadata
