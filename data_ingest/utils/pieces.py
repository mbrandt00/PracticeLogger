from dataclasses import dataclass
from typing import List, Optional

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
    key_signature: Optional[str] = None
    movements: Optional[List[Movement]] = None
    instrumentation: Optional[List[str]] = None


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

    print("-------")
    print(f"KEYS: {meta_attributes}")

    movements = parse_movements(data)
    return Piece(
        title=meta_attributes["work_title"],
        movements=movements,
        catalogue_type=meta_attributes["catalogue_type"],
        catalogue_number=meta_attributes["catalogue_number"],
        key_signature=meta_attributes["key_signature"],
        opus_catalogue_number_op_cat_no=meta_attributes[
            "opus_catalogue_number_op_cat_no"
        ],
    )


def parse_metadata(data: dict):
    """
    Parse and standardize metadata from the input dictionary.

    :param data: Dictionary containing raw metadata.
    :return: Processed metadata dictionary with standardized keys and renamed attributes.
    """
    # Mapping for renaming keys
    rename_map = {
        "movements_sections_mov_ts_sec_s": "movement_sections_count",
        "key": "key_signature",
    }

    # Standardize dictionary: Convert keys to snake_case and replace empty strings with None
    metadata_dict = convert_empty_vals_to_none(data)
    metadata_dict = standardize_dict_keys(metadata_dict)

    if not metadata_dict:
        raise ValueError("no metadata dict")

    metadata_dict["catalogue_type"] = None
    metadata_dict["catalogue_number"] = None

    for key in list(rename_map):
        print(f"Renaming key: {key} to {rename_map[key]}")
        # Assign the new value to the new key
        if key in metadata_dict:
            metadata_dict[rename_map[key]] = metadata_dict.pop(key)

    for key in list(metadata_dict.keys()):
        if key == "opus_catalogue_number_op_cat_no":
            opus_value = metadata_dict[key]
            if opus_value:
                catalogue_string = opus_value.replace(".", " ").split()

                if len(catalogue_string) >= 2:  # Ensure at least two components
                    metadata_dict["catalogue_type"] = catalogue_string[0]
                    metadata_dict["catalogue_number"] = int(catalogue_string[1])

        if key == "key_signature":
            metadata_dict[key] = parse_key_signature(metadata_dict[key])

    return metadata_dict
