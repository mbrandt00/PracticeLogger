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
    
    
    if not general_info_div or not isinstance(general_info_div, Tag):
        raise ValueError("Could not find 'div' with class 'wi_body'")
    
    #  try to get movements from ordered list (ol)
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
            key_sig_pattern = r"\([^)]*(?:major|minor)[^)]*\)"
            name = re.sub(key_sig_pattern, "", name).strip()
            base_title = re.sub(r'\s*\[.*?\].*$', '', name).strip()
            
            cleansed_name = re.search(number_title_pattern, base_title)
            movement.title = cleansed_name.group(2).strip() if cleansed_name else base_title
            
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
                        main_text += element.get_text()
                    else:
                        main_text += str(element)
                
                movement = Movement(
                    key_signature=None,
                    number=index + 1,
                    title=main_text.strip()
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
                key_sig_pattern = r"\([^)]*(?:major|minor)[^)]*\)"
                name = re.sub(key_sig_pattern, "", name).strip()
                base_title = re.sub(r'\s*\[.*?\].*$', '', name).strip()
                
                # Clean number prefix
                if base_title.startswith(f"{index + 1}."):
                    base_title = base_title[len(f"{index + 1}."):]
                
                # Clean up italics and extra spaces from title
                base_title = re.sub(r'<[^>]+>', '', base_title).strip()
                
                # Update the title
                movement.title = base_title.strip()
                
                nickname_pattern = r"['\"](.*?)['\"]"
                nickname_potential = re.findall(nickname_pattern, movement.title)
                if len(nickname_potential) == 1:
                    movement.nickname = nickname_potential[0]
                    
                bad_characters = ["{", "p.", "monatsbericht"]
                if any(bad in movement.title.lower() for bad in bad_characters):
                    continue
                    
                if movement.key_signature:
                    movement.download_url = section_download_link(data, movement.title)
                movements.append(movement)
    
    return movements
