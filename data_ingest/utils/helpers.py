import re
import logging

from typing import Dict, Optional

from bs4 import BeautifulSoup, Tag


def convert_empty_vals_to_none(data: dict) -> Dict:
    """
    Converts empty strings ('') in a dictionary to None at the top level.

    Args:
        data (dict): The dictionary to process.

    Returns:
        dict: The modified dictionary with '' replaced by None.
    """
    return {key: (None if value == "" else value) for key, value in data.items()}


def standardize_dict_keys(data: dict) -> Optional[Dict]:
    """
    Recursively processes a dictionary:
    - Converts keys to snake_case
    - Replaces empty strings with None
    - Handles nested dictionaries
    - Raises ValueError if the input is not a dictionary

    :param data: A dictionary with string keys and string values
    :return: A processed dictionary with snake_case keys and no empty strings
    :raises ValueError: If the input is not a dictionary
    """

    def process_key(key: str) -> str:
        # Replace spaces and special characters with underscores
        key = key.strip().replace(" ", "_")
        key = re.sub(r"(?<!^)(?=[A-Z])", "_", key)  # Convert CamelCase to snake_case
        key = re.sub(r"[^\w]", "_", key)  # Replace non-alphanumeric chars with _
        key = re.sub(r"_+", "_", key)  # Collapse multiple underscores to one
        return key.lower().strip(
            "_"
        )  # Ensure lowercase and remove trailing underscores

    if not isinstance(data, dict):
        raise ValueError("TESTSEKLTJ:LKJ")

    # Recursively process the dictionary
    return {
        process_key(k): standardize_dict_keys(v)
        if isinstance(v, dict)
        else (None if v == "" else v)
        for k, v in data.items()
    }


def parse_key_signature(raw_string: str) -> Optional[str]:
    """Parses a key signature string and returns the root note with its quality (e.g., 'csharp', 'dflat')."""
    soup = BeautifulSoup(raw_string, "html.parser")

    clean_string = (
        soup.get_text()
        .replace("\xa0", "")
        .replace("♯", "sharp")
        .replace("♭", "flat")
        .replace("-", " ")
        .strip()
    )
    # Regular expression pattern to match root notes and qualities
    pattern = r"([A-Ga-g])\s*(sharp|flat|)?\s*(major|minor)?"
    match = re.search(pattern, clean_string)

    if match:
        root = match.group(1).lower()  # Root note in lowercase
        accidental = match.group(2)  # "sharp" or "flat"
        quality = match.group(3)  # "major" or "minor"

        if accidental:
            root += accidental
        if quality:
            if quality.lower() == "minor":
                return root + "minor"
            return root
        return root
    else:
        # logging.exception("Invalid key signature %s", raw_string)
        raise ValueError("Invalid key signature format")


def section_download_link(data: Tag, piece_name: str) -> str | None:
    """Return the download URL of the file with the most downloads for a piece that matches"""
    # TODO: Under 10 mb for single movement, Beethoven No. 32 (ii) returns 130 mb file
    matching_files = []
    parent_div = data.find("div", id="wpscore_tabs")

    if parent_div and isinstance(parent_div, Tag):
        file_download_divs = parent_div.find_all(
            "div", class_="we_file_download plainlinks"
        )

        for div in file_download_divs:
            download_text = div.find("a", class_="external text").get_text(strip=True)
            if piece_name.lower() in download_text.lower():
                # Extract the number of downloads
                downloads_text = div.find("span", title="Total number of downloads")
                if downloads_text:
                    # Extract the actual number from the text (e.g., "3694×" -> 3694)
                    try:
                        downloads = int(
                            downloads_text.get_text(strip=True).replace("×", "").strip()
                        )
                    except ValueError:
                        downloads = 0  # If there's no valid number, assume 0 downloads
                    matching_files.append((div, downloads))
                else:
                    # If no download count is found, treat it as 0 downloads
                    matching_files.append((div, 0))

        if matching_files:
            # Sort the files by number of downloads in descending order
            best_file = max(matching_files, key=lambda x: x[1])
            # Extract the URL of the file with the most downloads
            best_file_url = best_file[0].find("a", class_="external text")["href"]
            return best_file_url

    else:
        return None
