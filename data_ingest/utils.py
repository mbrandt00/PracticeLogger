import re

from bs4 import BeautifulSoup, NavigableString, Tag


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

   
def parse_movements(data: Tag | NavigableString):
    movements = []

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
    piece_list = data.find("dl")
    if piece_list and isinstance(piece_list, Tag):
        print(piece_list.find_all("dd"))
        for index, dd in enumerate(piece_list.find_all("dd")):
            line = dd.get_text(strip=True).replace("\xa0", " ")
            number = index + 1

            if "(" in line and line.endswith(")"): # key signature exists
                name, key_signature = line.rsplit("(", 1)
                movements.append(
                    {
                        "type": "piece",
                        "number": number,
                        "name": name.strip(),
                        "key_signature": parse_key_signature(key_signature.strip()),
                    }
                )
            else:
                movements.append(
                    {
                        "type": "piece",
                        "number": number,
                        "name": line.strip(),
                        "key_signature": None,
                    }
                )
    print(f"movements {movements}")
    return movements
