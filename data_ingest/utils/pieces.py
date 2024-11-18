from dataclasses import dataclass, field
from typing import List, Optional

from bs4 import Tag
from helpers import convert_empty_vals_to_none, standardize_dict_keys
from movements import Movement, parse_movements


@dataclass
class Work:
    id: str
    title: str
    opus: Optional[int] = None
    number: Optional[int] = None
    key_signature: Optional[str] = None
    movements: List[Movement] = field(default_factory=list)

def create_piece(data: Tag):
    general_info_div = data.find("div", class_="wi_body")

    metadata = {}
    if general_info_div and isinstance(general_info_div, Tag):
        for row in general_info_div.find_all('tr'):
            th = row.find('th')
            td = row.find('td')
        
            if th and td:
                # Strip any extra spaces and add the data to the metadata dictionary
                metadata[th.get_text(strip=True)] = td.get_text(strip=True)

    meta_attributes = parse_metadata(metadata)    

    print('-------')
    print(f"KEYS: {meta_attributes}")

    movements = parse_movements(data)
    print(f"MOVEMENTS: {movements}")


def parse_metadata(data: dict): 
    """
    Parse and standardize metadata from the input dictionary.

    :param data: Dictionary containing raw metadata.
    :return: Processed metadata dictionary with standardized keys and renamed attributes.
    """
    # Mapping for renaming keys
    rename_map = {"movements_sections_mov_ts_sec_s": 'movement_sections_count'}
    
    # Standardize dictionary: Convert keys to snake_case and replace empty strings with None
    metadata_dict = convert_empty_vals_to_none(data)
    metadata_dict = standardize_dict_keys(metadata_dict) 
    
    # Check if there are keys to rename
    if metadata_dict: 
        for key in list(metadata_dict.keys()):  # We use list() to avoid runtime error while modifying dict during iteration
            if key in rename_map:
                print(f"Renaming key: {key} to {rename_map[key]}")
                # Assign the new value to the new key
                metadata_dict[rename_map[key]] = metadata_dict.pop(key)
    else:
        raise ValueError("No data to parse")
    return metadata_dict
