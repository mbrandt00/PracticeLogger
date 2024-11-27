import logging
import re
from dataclasses import dataclass
from typing import List, Optional
import requests

from bs4 import Tag, BeautifulSoup
from helpers import parse_key_signature, section_download_link


@dataclass
class Movement:
    title: str
    number: int
    key_signature: Optional[str] = None
    download_url: Optional[str] = None
    nickname: Optional[str] = None


def parse_movements(
    data: Optional[Tag] = None, url: Optional[str] = None
) -> List[Movement]:
    if not data and not url:
        raise ValueError("No data or url argument found")

    if url:
        response = requests.get(url, timeout=10)
        data = BeautifulSoup(response.text, "html.parser")

    if not data:
        raise ValueError("Beautiful soup object could not be initialized")

    general_info_div = data.find("div", class_="wi_body")

    movements = []
    number_title_pattern = r"(\d+)\.\s*([A-Za-z ]+)"

    def normalize_key_signature(text: str) -> str:
        # Replace dashes with spaces within parentheses
        in_parentheses = False
        result = []
        for char in text:
            if char == "(":
                in_parentheses = True
            elif char == ")":
                in_parentheses = False
            elif char == "-" and in_parentheses:
                result.append(" ")
            else:
                result.append(char)
        return "".join(result)

    def clean_title(title: str) -> str:
        # Remove empty parentheses and clean up extra whitespace
        cleaned = re.sub(r"\(\s*\)", "", title)
        cleaned = re.sub(r"\s+", " ", cleaned)
        return cleaned.strip()

    # Updated patterns to handle both formats
    key_signature_parentheses_pattern = (
        r"\((\b[A-Ga-g][♭#]?(?:(?:-|\s+)(?:sharp|flat))?\s*(?:major|minor)\b)\)"
    )
    key_signature_inline_pattern = (
        r"\b([A-Ga-g][♭#]?(?:(?:-|\s+)(?:sharp|flat))?\s*(?:major|minor))\b"
    )

    if not general_info_div or not isinstance(general_info_div, Tag):
        raise ValueError("Could not find 'div' with class 'wi_body'")

    for container, item_tag, movement_type in [
        (general_info_div.find("ol"), "li", "movement"),
        (general_info_div.find("dl"), "dd", "piece"),
    ]:
        if container and isinstance(container, Tag):
            for index, item in enumerate(container.find_all(item_tag)):
                line = item.get_text(strip=True).replace("\xa0", " ")
                # Normalize the line for key signature matching
                normalized_line = normalize_key_signature(line)

                movement = Movement(
                    key_signature=None, number=index + 1, title=line.strip()
                )

                valid_key_signature = None
                name = line

                # Step 1: Check for key signature in parentheses
                match_parentheses = re.search(
                    key_signature_parentheses_pattern, normalized_line
                )
                if match_parentheses:
                    potential_key_signature = match_parentheses.group(1).strip()
                    try:
                        valid_key_signature = parse_key_signature(
                            potential_key_signature
                        )
                        # Remove the matched parenthetical expression from the name
                        name = name.replace(match_parentheses.group(0), "").strip()
                    except ValueError:
                        logging.warning(
                            f"Invalid key signature in parentheses: {potential_key_signature}"
                        )

                # Step 2: If no valid parentheses match, check inline key signature
                if not valid_key_signature:
                    match_inline = re.search(
                        key_signature_inline_pattern, normalized_line
                    )
                    if match_inline:
                        potential_key_signature = match_inline.group(1).strip()
                        try:
                            valid_key_signature = parse_key_signature(
                                potential_key_signature
                            )
                            # Extract the matched text from the original line for removal
                            original_match = re.search(
                                rf"\b{re.escape(match_inline.group(0))}\b", line
                            )
                            if original_match:
                                name = name.replace(original_match.group(0), "").strip()
                        except ValueError:
                            logging.warning(
                                f"Invalid inline key signature: {potential_key_signature}"
                            )

                # Also check for "in X minor/major" format
                if not valid_key_signature:
                    in_key_pattern = r"in\s+([A-Ga-g][♭#]?(?:(?:-|\s+)(?:sharp|flat))?\s*(?:major|minor))"
                    match_in_key = re.search(in_key_pattern, normalized_line)
                    if match_in_key:
                        potential_key_signature = match_in_key.group(1).strip()
                        try:
                            valid_key_signature = parse_key_signature(
                                potential_key_signature
                            )
                        except ValueError:
                            logging.warning(
                                f"Invalid 'in key' signature: {potential_key_signature}"
                            )

                # Clean up the title
                cleansed_name = re.search(number_title_pattern, name)
                cleansed_title = (
                    cleansed_name.group(2).strip() if cleansed_name else name.strip()
                )
                # Clean up any remaining empty parentheses
                cleansed_title = clean_title(cleansed_title)

                nickname_pattern = r"['\"](.*?)['\"]"
                nickname_potential = re.findall(nickname_pattern, line)
                if len(nickname_potential) > 1:
                    raise ValueError(
                        f"found two potential nicknames: {nickname_potential}"
                    )
                elif len(nickname_potential) == 1:
                    movement.nickname = nickname_potential[0]

                # Set movement properties
                movement.title = (
                    cleansed_title if movement_type == "piece" else clean_title(name)
                )

                # Check for bad characters before appending
                bad_characters = ["{", "p.", "monatsbericht"]
                if any(bad in movement.title.lower() for bad in bad_characters):
                    logging.warning(
                        f"Title for movement malformed, skipping: {movement.title}"
                    )
                    continue

                # If we found a valid key signature, set it
                if valid_key_signature:
                    movement.key_signature = valid_key_signature
                    movement.download_url = section_download_link(data, cleansed_title)
                    movements.append(movement)
                else:
                    logging.warning(f"No valid key signature found in line: {line}")
                    movements.append(movement)

    return movements
