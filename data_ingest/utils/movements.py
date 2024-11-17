import re

from bs4 import BeautifulSoup, Tag


def parse_movements(data: Tag) -> list:
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

                    movement.update(
                        {
                            "name": cleansed_title
                            if movement_type == "piece"
                            else name.strip(),
                            "key_signature": _parse_key_signature(
                                key_signature.strip()
                            ),
                            "download_url": _section_download_link(
                                data, cleansed_title
                            ),
                        }
                    )

                movements.append(movement)

    return movements


def _parse_key_signature(raw_string: str) -> str:
    """Parses a key signature string and returns the root note with its quality (e.g., 'csharp', 'dflat')."""
    soup = BeautifulSoup(raw_string, "html.parser")

    clean_string = (
        soup.get_text()
        .replace("\xa0", "")
        .replace("♯", "sharp")
        .replace("♭", "flat")
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
        raise ValueError("Invalid key signature format")


def _section_download_link(data: Tag, piece_name: str) -> str | None:
    """Return the download URL of the file with the most downloads for a piece that matches"""
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
