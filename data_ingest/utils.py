import re

from bs4 import BeautifulSoup, Tag


def parse_key_signature(raw_string: str) -> str:
    """Parses a key signature string and returns the root note with its quality (e.g., 'csharp', 'dflat')."""
    soup = BeautifulSoup(raw_string, "html.parser")
    
    clean_string = soup.get_text().replace("\xa0", "").replace("♯", "sharp").replace("♭", "flat").strip()
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

   
def section_download_link(data: Tag, piece_name: str) -> str | None:
    """Return the download URL of the file with the most downloads for a piece that matches"""
    matching_files = []
    parent_div = data.find('div', id='wpscore_tabs')
    
    if parent_div and isinstance(parent_div, Tag):
        file_download_divs = parent_div.find_all('div', class_='we_file_download plainlinks')
        
        for div in file_download_divs:
            download_text = div.find('a', class_='external text').get_text(strip=True)
            if piece_name.lower() in download_text.lower():
                # Extract the number of downloads
                downloads_text = div.find('span', title="Total number of downloads")
                if downloads_text:
                    # Extract the actual number from the text (e.g., "3694×" -> 3694)
                    try:
                        downloads = int(downloads_text.get_text(strip=True).replace('×', '').strip())
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
            best_file_url = best_file[0].find('a', class_='external text')['href']
            return best_file_url

    else:
        return None
    
    

def parse_movements(data: Tag):
    movements = []

    general_info_div = data.find("div", class_="wi_body")
    if not general_info_div or not isinstance(general_info_div, Tag):
        raise ValueError("Could not find 'div' with class 'wi_body'")
    # movement_list = data.find("ol")
    # if movement_list:
    #     print("movement list")
    #     print(movement_list)
    #     for _, li in enumerate(movement_list.find_all("li")):
    #         line = li.get_text(strip=True).replace("\xa0", " ")
    #         number = 3
    #
    #         if "(" in line and line.endswith(")"):
    #             name, key_signature = line.rsplit("(", 1)
    #             key_signature = key_signature.rstrip(")").replace("\xa0", " ")
    #             movements.append(
    #                 {
    #                     "type": "movement",
    #                     "number": number,
    #                     "name": name.strip(),
    #                     "key_signature": key_signature.strip(),
    #                 }
    #             )
    #         else:
    #             movements.append(
    #                 {
    #                     "type": "movement",
    #                     "number": number,
    #                     "name": line.strip(),
    #                     "key_signature": None,
    #                 }
    #             )
    piece_list = general_info_div.find("dl")
    if piece_list and isinstance(piece_list, Tag):
        for index, dd in enumerate(piece_list.find_all("dd")):
            line = dd.get_text(strip=True).replace("\xa0", " ")
            number = index + 1

            number_title_pattern = r"(\d+).\s*([A-Za-z ]+)"
            if "(" in line and line.endswith(")"): # key signature exists
                name, key_signature = line.rsplit("(", 1)
                cleansed_name = re.search(number_title_pattern, name)

                if cleansed_name:
                    cleansed_title = cleansed_name.group(2).strip()
                else:
                    cleansed_title = name.strip()  # Fallback to the original name if no match             
                movements.append(
                    {
                        "type": "piece",
                        "number": number,
                        "name": cleansed_title,
                        "download_url": section_download_link(data, cleansed_title),
                        "key_signature": parse_key_signature(key_signature.strip()),
                    }
                )
            else:
                movements.append(
                    {
                        "type": "piece",
                        "number": number,
                        "name": re.search(number_title_pattern, line.strip()),
                        "key_signature": None,
                    }
                )
    return movements
