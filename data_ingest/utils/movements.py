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
    # Pattern to match key signature information within parentheses
    key_signature_pattern = r"\(([^)]*(?:major|minor)[^)]*)\)"

    general_info_div = data.find("div", class_="wi_body")
    if not general_info_div or not isinstance(general_info_div, Tag):
        raise ValueError("Could not find 'div' with class 'wi_body'")

    for container, item_tag, movement_type in [
        (general_info_div.find("ol"), "li", "movement"),
        (general_info_div.find("dl"), "dd", "piece"),
    ]:
        if container and isinstance(container, Tag):
            for index, item in enumerate(container.find_all(item_tag)):
                line = item.get_text(strip=True).replace("\xa0", " ")
                movement = Movement(
                    key_signature=None, number=index + 1, title=line.strip()
                )

                # Find all parenthetical expressions that might contain key signatures
                key_signature_matches = re.finditer(key_signature_pattern, line)
                valid_key_signature = None
                name = line

                # Try each parenthetical expression until we find a valid key signature
                for match in key_signature_matches:
                    potential_key_signature = match.group(1).strip()
                    try:
                        parsed_key_signature = parse_key_signature(
                            potential_key_signature
                        )
                        valid_key_signature = parsed_key_signature
                        # Remove the matched parenthetical expression from the name
                        name = name.replace(match.group(0), "").strip()
                        break  # Stop after finding the first valid key signature
                    except ValueError:
                        continue

                # Clean up the title
                cleansed_name = re.search(number_title_pattern, name)
                cleansed_title = (
                    cleansed_name.group(2).strip() if cleansed_name else name.strip()
                )

                # Set movement properties
                movement.title = cleansed_title if movement_type == "piece" else name

                # Check for bad characters before appending
                bad_characters = ['{', 'p.', 'monatsbericht']
                if any(bad in movement.title.lower() for bad in bad_characters):
                    logging.warning("Title for movement malformed, skipping: %s", movement.title)
                    continue  # Skip this movement if a bad character is found

                # If we found a valid key signature, set it
                if valid_key_signature:
                    movement.key_signature = valid_key_signature
                    movement.download_url = section_download_link(data, cleansed_title)
                    movements.append(movement)
                else:
                    logging.warning("No valid key signature found in line: %s", line)
                    movements.append(movement)

    return movements