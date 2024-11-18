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
    desired_attributes = ['Composition Years']
    rename_map = {"movements_sections_mov'ts_sec's": 'movement_sections_count'}
    
    # Standardize dictionary: Convert keys to snake_case and replace empty strings with None
    metadata_dict = convert_empty_vals_to_none(data)
    metadata_dict = standardize_dict_keys(metadata_dict)
    # 
    # # Filter for desired attributes
    if metadata_dict: 
        metadata_dict = {
            key: metadata_dict[key]
            for key in metadata_dict.keys()
            if key in [standardize_dict_keys(attr) for attr in desired_attributes]
        }
    # 
    # # Rename keys based on rename_map
    # renamed_metadata = {
    #     rename_map.get(key, key): value
    #     for key, value in filtered_metadata.items()
    # }

    return metadata_dict
