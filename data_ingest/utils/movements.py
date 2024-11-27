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

    def clean_title(title: str) -> str:
        # Remove empty parentheses and clean up extra whitespace
        cleaned = re.sub(r"\(\s*\)", "", title)
        cleaned = re.sub(r"\s+", " ", cleaned)
        return cleaned.strip()

    if not general_info_div or not isinstance(general_info_div, Tag):
        raise ValueError("Could not find 'div' with class 'wi_body'")

    for container, item_tag, movement_type in [
        (general_info_div.find("ol"), "li", "movement"),
        (general_info_div.find("dl"), "dd", "piece"),
    ]:
        if container and isinstance(container, Tag):
            for index, item in enumerate(container.find_all(item_tag)):
                # Process the raw HTML directly for key signature parsing
                raw_html = str(item)
                movement = Movement(
                    key_signature=None, number=index + 1, title=item.get_text(strip=True)
                )

                # Try to parse key signature
                try:
                    valid_key_signature = parse_key_signature(raw_html)
                    if valid_key_signature:
                        movement.key_signature = valid_key_signature
                except ValueError:
                    logging.warning(f"Could not parse key signature from: {raw_html}")

                # Get clean text version for other processing
                line = item.get_text(strip=True).replace("\xa0", " ")
                name = line

                # Remove any parenthetical key signatures from the name
                key_sig_pattern = r"\([^)]*(?:major|minor)[^)]*\)"
                name = re.sub(key_sig_pattern, "", name).strip()

                # Extract base title without additional text in brackets
                base_title = re.sub(r'\s*\[.*?\].*$', '', name).strip()
                
                # Clean up the title
                cleansed_name = re.search(number_title_pattern, base_title)
                movement.title = cleansed_name.group(2).strip() if cleansed_name else base_title

                # Process nickname
                nickname_pattern = r"['\"](.*?)['\"]"
                nickname_potential = re.findall(nickname_pattern, line)
                if len(nickname_potential) > 1:
                    raise ValueError(
                        f"found two potential nicknames: {nickname_potential}"
                    )
                elif len(nickname_potential) == 1:
                    movement.nickname = nickname_potential[0]

                # Check for bad characters before appending
                bad_characters = ["{", "p.", "monatsbericht"]
                if any(bad in movement.title.lower() for bad in bad_characters):
                    logging.warning(
                        f"Title for movement malformed, skipping: {movement.title}"
                    )
                    continue

                # Set download URL if we have a key signature
                if movement.key_signature:
                    movement.download_url = section_download_link(data, movement.title)

                movements.append(movement)

    return movements