import pytest
from bs4 import BeautifulSoup

from utils.pieces import create_piece, parse_metadata


def test_parse_metadata():
    sample_data = {
        "Incipit": "movements:1:2:3 (minuet):3 (trio):4:",
        "Movements/SectionsMov'ts/Sec's": "4 movements",
        "year_date_of_composition_y_d_of_comp": "1793-95",
        "Work Title": "Test name",
    }
    # print(type(sample_data))
    parsed = parse_metadata(sample_data)
    keys_to_check = ["movement_sections_count", "composition_year"]

    assert all(key in parsed for key in keys_to_check)
    print(f"parsed: {parsed}")
    assert parsed["movement_sections_count"] == "4 movements"
    assert parsed["composition_year_string"] == "1793-95"
    assert parsed["composition_year"] == 1793


@pytest.mark.parametrize(
    "html_file, expected_data",
    [
        (
            "tests/scrape_responses/chopin_cello_sonata.html",
            {
                "catalogue_number": 65,
                "title": "Cello Sonata",
                "catalogue_type": "Op",
                "composition_year_string": "1846-1847 (summer)",
                "composition_year": 1846,
                "key_signature": "gminor",
                "movements_count": 4,
            },
        ),
        (
            "tests/scrape_responses/appasionata_piece.html",
            {
                "catalogue_number": 57,
                "title": "Piano Sonata No.23",
                "catalogue_type": "Op",
                "composition_year_string": "1804–06",
                "composition_year": 1804,
                "key_signature": "fminor",
                "movements_count": 3,
            },
        ),
    ],
)
def test_create_piece(html_file, expected_data):
    with open(html_file) as file:
        soup = BeautifulSoup(file, "html.parser")
        data = create_piece(soup)

    assert data.catalogue_number == expected_data["catalogue_number"]
    assert data.title == expected_data["title"]
    assert data.catalogue_type == expected_data["catalogue_type"]
    assert data.composition_year_string == expected_data["composition_year_string"]
    assert data.composition_year == expected_data["composition_year"]
    assert len(data.movements) == expected_data["movements_count"]
    assert data.key_signature == expected_data["key_signature"]
