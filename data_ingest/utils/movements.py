import logging
import re
from dataclasses import dataclass
from typing import List, Optional

import requests
from bs4 import BeautifulSoup, Tag
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
    # Add patterns for tempo markings
    tempo_pattern = r"\s*[♩♪𝅗𝅥𝅘𝅥𝅮]\s*=\s*\d+\s*"  # Basic pattern for musical note symbols
    extended_tempo_pattern = (
        r"\s*(?:<[^>]+>)*\s*=\s*\d+\s*"  # Pattern that handles HTML image tags
    )

    if not general_info_div or not isinstance(general_info_div, Tag):
        raise ValueError("Could not find 'div' with class 'wi_body'")

    # try to get movements from ordered list (ol)
    ol_container = general_info_div.find("ol")
    if ol_container and isinstance(ol_container, Tag):
        for index, item in enumerate(ol_container.find_all("li")):
            # Process the raw HTML directly for key signature parsing
            raw_html = str(item)
            movement = Movement(
                key_signature=None, number=index + 1, title=item.get_text(strip=True)
            )
            try:
                valid_key_signature = parse_key_signature(raw_html)
                if valid_key_signature:
                    movement.key_signature = valid_key_signature
            except ValueError:
                logging.warning(f"Could not parse key signature from: {raw_html}")

            line = item.get_text(strip=True).replace("\xa0", " ")
            name = line

            # Remove key signatures and tempo markings from parentheses
            key_sig_pattern = r"\([^)]*(?:major|minor)[^)]*\)"
            name = re.sub(key_sig_pattern, "", name).strip()
            # Remove parentheses containing tempo markings
            name = re.sub(r"\([^)]*(?:=\s*\d+)[^)]*\)", "", name).strip()
            # Remove any remaining tempo markings
            name = re.sub(tempo_pattern, "", name).strip()
            name = re.sub(extended_tempo_pattern, "", name).strip()
            # Remove any double spaces created by the removals
            name = re.sub(r"\s+", " ", name).strip()

            base_title = re.sub(r"\s*\[.*?\].*$", "", name).strip()

            cleansed_name = re.search(number_title_pattern, base_title)
            movement.title = (
                cleansed_name.group(2).strip() if cleansed_name else base_title
            )

            nickname_pattern = r"['\"](.*?)['\"]"
            nickname_potential = re.findall(nickname_pattern, line)
            if len(nickname_potential) == 1:
                movement.nickname = nickname_potential[0]

            bad_characters = ["{", "p.", "monatsbericht"]
            if any(bad in movement.title.lower() for bad in bad_characters):
                continue

            if movement.key_signature:
                movement.download_url = section_download_link(data, movement.title)
            movements.append(movement)

    # Only if no movements were found in ol, try dl
    if not movements:
        dl_container = general_info_div.find("dl")
        if dl_container and isinstance(dl_container, Tag):
            for index, item in enumerate(dl_container.find_all("dd", recursive=False)):
                # Get the main movement title first
                raw_html = str(item)

                # Extract title from the first part, before any nested dl
                main_text = ""
                for element in item.children:
                    if isinstance(element, Tag):
                        if element.name == "dl":
                            break
                        # Skip <a> tags and their content
                        elif element.name == "a":
                            continue
                        # For span tags that might contain links
                        elif element.name == "span":
                            # Skip if it's a plainlinks span containing links
                            if "plainlinks" in element.get("class", []):
                                continue
                            main_text += element.get_text()
                        else:
                            main_text += element.get_text()
                    else:
                        # Only add text content if it's not just whitespace or semicolons
                        text = str(element).strip()
                        if text and text not in [";", " ;"]:
                            main_text += text

                movement = Movement(
                    key_signature=None, number=index + 1, title=main_text.strip()
                )

                # Check for nested dl/dd with additional info
                nested_dl = item.find("dl")
                if nested_dl:
                    nested_dd = nested_dl.find("dd")
                    if nested_dd:
                        # Combine both for key signature parsing
                        raw_html = str(item) + str(nested_dd)

                try:
                    valid_key_signature = parse_key_signature(raw_html)
                    if valid_key_signature:
                        movement.key_signature = valid_key_signature
                except ValueError:
                    logging.warning(f"Could not parse key signature from: {raw_html}")

                name = movement.title
                # Remove key signatures and tempo markings from parentheses
                key_sig_pattern = r"\([^)]*(?:major|minor)[^)]*\)"
                name = re.sub(key_sig_pattern, "", name).strip()
                # Remove parentheses containing tempo markings
                name = re.sub(r"\([^)]*(?:=\s*\d+)[^)]*\)", "", name).strip()
                # Remove any remaining tempo markings
                name = re.sub(tempo_pattern, "", name).strip()
                name = re.sub(extended_tempo_pattern, "", name).strip()
                # Remove any double spaces created by the removals
                name = re.sub(r"\s+", " ", name).strip()

                base_title = re.sub(r"\s*\[.*?\].*$", "", name).strip()

                # Clean number prefix
                base_title = re.sub(r"^\d+\.\s*", "", base_title)

                # Extract key signature from the title if present
                key_pattern = r"\((.*?(?:major|minor).*?)\)"
                key_match = re.search(key_pattern, base_title)
                if key_match:
                    base_title = re.sub(r"\s*\(.*?(?:major|minor).*?\)", "", base_title)

                # Clean up italics and extra spaces from title
                base_title = re.sub(r"<[^>]+>", "", base_title).strip()

                # Update the title
                movement.title = base_title.strip()

                nickname_pattern = r"['\"](.*?)['\"]"
                nickname_potential = re.findall(nickname_pattern, movement.title)
                if len(nickname_potential) == 1:
                    movement.nickname = nickname_potential[0]
                    # Remove the nickname from the title
                    movement.title = re.sub(
                        r'\s*[\'"].*?[\'"]\s*', "", movement.title
                    ).strip()

                bad_characters = ["{", "p.", "monatsbericht"]
                if any(bad in movement.title.lower() for bad in bad_characters):
                    continue

                if movement.key_signature:
                    movement.download_url = section_download_link(data, movement.title)
                movements.append(movement)

    return movements
