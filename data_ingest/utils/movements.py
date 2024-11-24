import logging
import re
from dataclasses import dataclass
from typing import List, Optional

from bs4 import Tag
from helpers import parse_key_signature, section_download_link


@dataclass
class Movement:
    title: str
    number: int
    key_signature: Optional[str] = None
    download_url: Optional[str] = None


def parse_movements(data: Tag) -> List[Movement]:
    movements = []
    number_title_pattern = r"(\d+)\.\s*([A-Za-z ]+)"
    general_info_div = data.find("div", class_="wi_body")
    if not general_info_div or not isinstance(general_info_div, Tag):
        raise ValueError("Could not find 'div' with class 'wi_body'")

    # Process both movement list (ol/li) and piece list (dl/dd)
    for container, item_tag, movement_type in [
        (general_info_div.find("ol"), "li", "movement"),
        (general_info_div.find("dl"), "dd", "piece"),
    ]:
        if container and isinstance(container, Tag):
            for index, item in enumerate(container.find_all(item_tag)):
                line = item.get_text(strip=True).replace("\xa0", " ")
                movement = Movement(key_signature=None, number=index + 1, title=line.strip())
                
                if "(" in line and line.endswith(")"):
                    name, key_signature = line.rsplit("(", 1)
                    key_signature = key_signature.rstrip(")")  # Remove trailing parenthesis
                    cleansed_name = re.search(number_title_pattern, name)
                    cleansed_title = (
                        cleansed_name.group(2).strip()
                        if cleansed_name
                        else name.strip()
                    )
                    
                    try:
                        # Parse the key signature from the key_signature string
                        parsed_key_signature = parse_key_signature(key_signature.strip())
                        # Set the title and key signature for the movement
                        movement.title = cleansed_title if movement_type == "piece" else name.strip()
                        movement.key_signature = parsed_key_signature

                        movement.download_url = section_download_link(data, cleansed_title)
                        
                        movements.append(movement)  # Append the populated movement object to the list
                    except ValueError:
                        # Log exception but continue processing other movements
                        logging.exception(
                            "Invalid key signature '%s' in line: %s", key_signature, line
                        )
            else:
                print("Continuing")
                continue

    return movements
