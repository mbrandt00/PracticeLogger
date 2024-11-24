from dataclasses import dataclass, field
from typing import Dict, List, Optional, TypedDict

import requests
from bs4 import BeautifulSoup, Tag
from helpers import (
    convert_empty_vals_to_none,
    parse_key_signature,
    standardize_dict_keys,
)
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


def create_piece(data: Optional[Tag] = None, url: Optional[str] = None) -> Piece:
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
                    parsed_data = td_text.split()
                    if len(parsed_data) > 2:
                        raise ValueError(
                            f"parsed data for movement section sub type analsyis is greater than 2: {parsed_data}"
                        )
                    else:
                        piece.sub_piece_count = int(parsed_data[0])
                        piece.sub_piece_type = parsed_data[1]

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


def parse_metadata(data: Dict[str, str]) -> PieceMetadata:
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
    print("METADATA_DICT", metadata_dict)

    if not metadata_dict:
        raise ValueError("no metadata dict")

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
            if (
                new_key in processed_metadata
            ):  # Only update if it's a field we care about
                processed_metadata[new_key] = value

    if opus_value := metadata_dict.get("opus_catalogue_number_op_cat_no"):
        processed_metadata["opus_catalogue_number_op_cat_no"] = opus_value
        split_catalogue_string = opus_value.replace(".", " ").split()
        if len(split_catalogue_string) >= 2:
            processed_metadata["catalogue_type"] = split_catalogue_string[0]
            try:
                processed_metadata["catalogue_number"] = int(split_catalogue_string[1])
            except ValueError:
                processed_metadata["catalogue_number"] = None

            # Look for "No" and extract the value after it
            if "No" in split_catalogue_string:
                no_index = split_catalogue_string.index("No")
                if no_index + 1 < len(split_catalogue_string):
                    try:
                        processed_metadata["catalogue_number_secondary"] = int(
                            split_catalogue_string[no_index + 1]
                        )
                    except ValueError:
                        processed_metadata["catalogue_number_secondary"] = None
            else:
                processed_metadata["catalogue_number_secondary"] = None

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
