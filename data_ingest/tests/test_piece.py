import pytest
from bs4 import BeautifulSoup

from utils.pieces import create_piece, parse_metadata


def test_parse_metadata():
    sample_data = {
        "Incipit": "movements:1:2:3 (minuet):3 (trio):4:",
        "Movements/SectionsMov'ts/Sec's": "4 movements",
        "Composition Year": "1793-95",
        "Work Title": "Test name"
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
        print("IN TEST")
        print(data)
        assert data.catalogue_number == 65
        assert data.title == 'Cello Sonata'
        assert data.catalogue_type == 'Op'
        assert data.composition_year == '1846-1847 (summer)'
        assert data.key_signature == 'gminor'
        assert len(data.movements) == 4
