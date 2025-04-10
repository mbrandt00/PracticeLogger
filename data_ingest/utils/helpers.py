import logging
import re
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
        raise ValueError("Data is not a dict")

    # Recursively process the dictionary
    return {
        process_key(k): standardize_dict_keys(v)
        if isinstance(v, dict)
        else (None if v == "" else v)
        for k, v in data.items()
    }


def parse_key_signature(raw_string: str) -> Optional[str]:
    """Parses a key signature string and returns the root note with its quality (e.g., 'csharp', 'dflat')."""
    # First, remove any Cyrillic text in parentheses to avoid false matches
    clean_raw = re.sub(r"\([^)]*[А-Яа-я][^)]*\)", "", raw_string)

    soup = BeautifulSoup(clean_raw, "html.parser")
    clean_string = (
        soup.get_text()
        .replace("\xa0", " ")
        .replace("♯", "sharp")
        .replace("♭", "flat")
        .replace("-", " ")
        .replace("=", " = ")
        .strip()
    )

    # First check for "in X" format
    in_key_pattern = r"in\s+([A-G])\s*(sharp|flat|♯|♭)?\s*(major|minor)?"
    in_match = re.search(in_key_pattern, clean_string, re.IGNORECASE)
    if in_match:
        root = in_match.group(1).lower()
        accidental = in_match.group(2)
        quality = in_match.group(3)
        result = root
        if accidental:
            accidental = accidental.lower().replace("♯", "sharp").replace("♭", "flat")
            result += accidental
        if quality and quality.lower() == "minor":
            result += "minor"
        return result

    # Try to find key signature in parentheses containing "major" or "minor"
    paren_pattern = r"\(([^)]*(?:major|minor)[^)]*)\)"
    paren_matches = list(re.finditer(paren_pattern, clean_string, re.IGNORECASE))
    key_string = clean_string

    if paren_matches:
        # Take the last parenthetical expression containing major/minor
        key_string = paren_matches[-1].group(1).strip()

    # Check if the string contains any Cyrillic characters
    if re.search("[А-Яа-я]", key_string):
        # If it contains Cyrillic, require explicit major/minor
        pattern = r"(?:^|\b)([A-G])\s*(sharp|flat|♯|♭)?\s*(major|minor)(?:\b|$)"
    else:
        # If no Cyrillic, allow more relaxed matching
        pattern = r"(?:^|\b)([A-G])\s*(sharp|flat|♯|♭)?(?:\s*(major|minor))?(?:\b|$)"

    match = re.search(pattern, key_string, re.IGNORECASE)

    if not match and not paren_matches:
        # Try the full string if parentheses match didn't work
        match = re.search(pattern, clean_string, re.IGNORECASE)

    if match:
        root = match.group(1).lower()
        accidental = match.group(2)
        quality = match.group(3)
        result = root
        if accidental:
            accidental = accidental.lower().replace("♯", "sharp").replace("♭", "flat")
            result += accidental
        if quality and quality.lower() == "minor":
            result += "minor"
        return result

    return None


def section_download_link(data: Tag, piece_name: str) -> str | None:
    """Return the download URL of the file with the most downloads for a piece that matches"""
    # Early return if parent div doesn't exist or is wrong type
    parent_div = data.find("div", id="wpscore_tabs")
    if not parent_div or not isinstance(parent_div, Tag):
        return None

    matching_files = []
    file_download_divs = parent_div.find_all(
        "div", class_="we_file_download plainlinks"
    )

    # Process each download div
    for div in file_download_divs:
        download_text = div.find("a", class_="external text").get_text(strip=True)
        if piece_name.lower() not in download_text.lower():
            continue

        # Get download count
        downloads = 0
        downloads_text = div.find("span", title="Total number of downloads")
        if downloads_text:
            try:
                downloads = int(
                    downloads_text.get_text(strip=True).replace("×", "").strip()
                )
            except ValueError:
                pass  # Keep downloads as 0 if parsing fails

        matching_files.append((div, downloads))

    # Return best matching file URL or None if no matches
    if not matching_files:
        return None

    best_file = max(matching_files, key=lambda x: x[1])
    return best_file[0].find("a", class_="external text")["href"]
