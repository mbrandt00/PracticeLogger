import re
from dataclasses import dataclass
from typing import List, Optional
import logging
from bs4 import Tag
from helpers import parse_key_signature, section_download_link


@dataclass
class Movement:
    id: str
    title: str
    number: int
    key_signature: Optional[str] = None


def parse_movements(data: Tag) -> List[Movement]:
    movements = []
    number_title_pattern = r"(\d+).\s*([A-Za-z ]+)"
    general_info_div = data.find("div", class_="wi_body")
    if not general_info_div or not isinstance(general_info_div, Tag):
        raise ValueError("Could not find 'div' with class 'wi_body'")

    # Process both movement list (ol/li) and piece list (dl/dd)
    for container, item_tag, movement_type in [
        (data.find("ol"), "li", "movement"),
        (general_info_div.find("dl"), "dd", "piece"),
    ]:
        if container and isinstance(container, Tag):
            for index, item in enumerate(container.find_all(item_tag)):
                line = item.get_text(strip=True).replace("\xa0", " ")
                movement = {
                    "type": movement_type,
                    "number": index + 1,
                    "name": line.strip(),
                    "key_signature": None,
                }

                if "(" in line and line.endswith(")"):
                    name, key_signature = line.rsplit("(", 1)
                    cleansed_name = re.search(number_title_pattern, name)
                    cleansed_title = (
                        cleansed_name.group(2).strip()
                        if cleansed_name
                        else name.strip()
                    )
                    try:
                        movement.update(
                            {
                                "name": cleansed_title
                                if movement_type == "piece"
                                else name.strip(),
                                "key_signature": parse_key_signature(
                                    key_signature.strip()
                                ),
                                "download_url": section_download_link(
                                    data, cleansed_title
                                ),
                            }
                        )
                    except ValueError as e:
                        # logging.exception('in movements, container: %s, e: %s', container, e)
                        return None

                movements.append(movement)
    return movements
