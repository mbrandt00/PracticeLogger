import pytest
from bs4 import BeautifulSoup

from utils.pieces import create_piece, parse_metadata


def test_parse_metadata():
    sample_data = {
        "Incipit": "movements:1:2:3 (minuet):3 (trio):4:",
        "Movements/SectionsMov'ts/Sec's": "4 movements",
        "Composition Year": "1793-95",
        "Genre Categories": "Sonatas;For piano;Scores featuring the piano;For 1 player;For orchestra (arr);Scores featuring the orchestra (arr);For strings (arr);Scores featuring string ensemble (arr);For clarinet, bassoon, horn, violin, viola, cello, double bass (arr);Scores featuring the clarinet (arr);Scores featuring the bassoon (arr);Scores featuring the horn (arr);Scores featuring the violin (arr);Scores featuring the viola (arr);Scores featuring the cello (arr);Scores featuring the double bass (arr);For 7 players (arr);For 2 violins, viola, cello (arr);For 4 players (arr);For 2 pianos (arr);Scores featuring the piano (arr);For 2 players (arr);For piano 4 hands (arr);Scores featuring the piano 4 hands (arr);For organ (arr);For 1 player (arr);Scores featuring the organ (arr)",
    }
    # print(type(sample_data))
    parsed = parse_metadata(sample_data)
    keys_to_check = ["movement_sections_count", "composition_year"]

    assert all(key in parsed for key in keys_to_check)
    assert parsed["movement_sections_count"] == "4 movements"
    assert parsed["composition_year"] == "1793-95"


def test_create_piece():
    with open("tests/scrape_responses/chopin_cello_sonata.html") as file:
        soup = BeautifulSoup(file, "html.parser")
        data = create_piece(soup)
        # 'opus_catalogue_number_op_cat_no': 'Op.65'
        print("IN TEST")
        print(data)
        assert data.catalogue_number == 65
