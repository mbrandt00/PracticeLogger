from dataclasses import dataclass, field
from typing import Dict, List, Optional, TypedDict

from bs4 import Tag
from helpers import (
    convert_empty_vals_to_none,
    parse_key_signature,
    standardize_dict_keys,
)
from movements import Movement, parse_movements


@dataclass
class Piece:
    title: str
    opus_catalogue_number_op_cat_no: Optional[str] = None
    catalogue_type: Optional[str] = None  # op, bmv, etc
    catalogue_number: Optional[int] = None
    catalogue_id: Optional[int] = None
    composition_year: Optional[int] = None
    composition_year_string: Optional[str] = None
    key_signature: Optional[str] = None
    movements: List[Movement] = field(default_factory=list)
    instrumentation: Optional[List[str]] = field(default_factory=list)


def create_piece(data: Tag) -> Piece:
    general_info_div = data.find("div", class_="wi_body")

    metadata = {}
    if general_info_div and isinstance(general_info_div, Tag):
        for row in general_info_div.find_all("tr"):
            th = row.find("th")
            td = row.find("td")

            if th and td:
                # Strip any extra spaces and add the data to the metadata dictionary
                metadata[th.get_text(strip=True)] = td.get_text(strip=True)

    meta_attributes = parse_metadata(metadata)

    movements = parse_movements(data)
    return Piece(
        title=meta_attributes["work_title"],
        movements=movements,
        composition_year_string=meta_attributes["composition_year_string"],
        composition_year=meta_attributes["composition_year"],
        catalogue_type=meta_attributes["catalogue_type"],
        catalogue_number=meta_attributes["catalogue_number"],
        key_signature=meta_attributes["key_signature"],
        instrumentation=meta_attributes["instrumentation"],
        opus_catalogue_number_op_cat_no=meta_attributes[
            "opus_catalogue_number_op_cat_no"
        ],
    )


class PieceMetadata(TypedDict):
    work_title: str
    opus_catalogue_number_op_cat_no: Optional[str]
    catalogue_type: Optional[str]
    catalogue_number: Optional[int]
    key_signature: Optional[str]
    composition_year_string: Optional[str]
    composition_year: Optional[int]
    instrumentation: Optional[List[str]]
    movement_sections_count: Optional[str]


def parse_metadata(data: Dict[str, str]) -> PieceMetadata:
    """
    Parse and standardize metadata from the input dictionary.

    Args:
        data: Dictionary containing raw metadata with string keys and values

    Returns:
        PieceMetadata: Processed metadata with standardized keys and proper types

    Raises:
        ValueError: If metadata dictionary is empty or work_title is missing
    """
    # Mapping for renaming keys
    rename_map = {
        "movements_sections_mov_ts_sec_s": "movement_sections_count",
        "key": "key_signature",
        "year_date_of_composition_y_d_of_comp": "composition_year_string",
    }

    # Standardize dictionary: Convert keys to snake_case and replace empty strings with None
    metadata_dict = convert_empty_vals_to_none(data)
    metadata_dict = standardize_dict_keys(metadata_dict)

    if not metadata_dict:
        raise ValueError("no metadata dict")

    # Initialize the processed metadata with default values
    processed_metadata: PieceMetadata = {
        "work_title": metadata_dict.get("work_title", ""),
        "opus_catalogue_number_op_cat_no": None,
        "instrumentation": None,
        "composition_year_string": None,
        "composition_year": None,
        "catalogue_type": None,
        "catalogue_number": None,
        "key_signature": None,
        "movement_sections_count": None,
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
        catalogue_string = opus_value.replace(".", " ").split()
        if len(catalogue_string) >= 2:
            processed_metadata["catalogue_type"] = catalogue_string[0]
            try:
                processed_metadata["catalogue_number"] = int(catalogue_string[1])
            except ValueError:
                processed_metadata["catalogue_number"] = None

    if key_sig := metadata_dict.get("key_signature"):
        parsed_key = parse_key_signature(key_sig)
        processed_metadata["key_signature"] = parsed_key
        metadata_dict.pop("key_signature")
    if comp_year := metadata_dict.get("composition_year_string"):
        processed_metadata["composition_year_string"] = comp_year
        processed_metadata["composition_year"] = (
            int(comp_year[:4]) if comp_year else None
        )

    # Process remaining fields
    for key in metadata_dict:
        processed_metadata[key] = metadata_dict[key]

    # Ensure work_title is present
    if not processed_metadata["work_title"]:
        raise ValueError("work_title is required but not found in metadata")

    return processed_metadata
