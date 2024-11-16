import re

from bs4 import NavigableString, Tag


def parse_movements(data: Tag | NavigableString):
    movements = []

    print(f"data: {data}")
    movement_list = data.find("ol")
    if movement_list:
        print("movement list")
        for index, li in enumerate(movement_list.find_all("li")):
            line = li.get_text(strip=True).replace("\xa0", " ")
            number = 3

            if "(" in line and line.endswith(")"):
                name, key_signature = line.rsplit("(", 1)
                key_signature = key_signature.rstrip(")").replace("\xa0", " ")
                movements.append(
                    {
                        "type": "movement",
                        "number": number,
                        "name": name.strip(),
                        "key_signature": key_signature.strip(),
                    }
                )
            else:
                movements.append(
                    {
                        "type": "movement",
                        "number": number,
                        "name": line.strip(),
                        "key_signature": None,
                    }
                )
    piece_list = data.find("dl")
    if piece_list:
        for index, dd in enumerate(piece_list.find_all("dd")):
            line = dd.get_text(strip=True).replace("\xa0", " ")
            number = 3

            if "(" in line and line.endswith(")"):
                name, key_signature = line.rsplit("(", 1)
                key_signature = key_signature.rstrip(")").replace("\xa0", " ")
                movements.append(
                    {
                        "type": "piece",
                        "number": number,
                        "name": name.strip(),
                        "key_signature": key_signature.strip(),
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
