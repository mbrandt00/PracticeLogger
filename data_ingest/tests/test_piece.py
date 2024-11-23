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
                "nickname": None,
                "instrumentation": ["cello", "piano"],
                "piece_style": "romantic",
            },
        ),
        (
            "tests/scrape_responses/appassionata_piece.html",
            {
                "catalogue_number": 57,
                "title": "Piano Sonata No.23",
                "catalogue_type": "Op",
                "composition_year_string": "1804–06",
                "composition_year": 1804,
                "key_signature": "fminor",
                "movements_count": 3,
                "nickname": "Appassionata",
                "instrumentation": ["piano"],
                "piece_style": "classical",
            },
        ),
    ],
)
def test_create_piece_from_tag(html_file, expected_data):
    with open(html_file) as file:
        soup = BeautifulSoup(file, "html.parser")
        data = create_piece(soup)

    assert data.catalogue_number == expected_data["catalogue_number"]
    assert data.work_name == expected_data["title"]
    assert data.catalogue_type == expected_data["catalogue_type"]
    assert data.composition_year_string == expected_data["composition_year_string"]
    assert data.composition_year == expected_data["composition_year"]
    assert len(data.movements) == expected_data["movements_count"]
    assert data.key_signature == expected_data["key_signature"]
    assert data.nickname == expected_data["nickname"]
    assert data.instrumentation == expected_data["instrumentation"]
    assert data.piece_style == expected_data["piece_style"]
  
@pytest.mark.parametrize(
    "url, expected_data",
    [
        ("https://imslp.org/wiki/Violin_Sonata_No.1%2C_Op.12_No.1_(Beethoven%2C_Ludwig_van)", {
                "catalogue_number": 12,
                "title": "Violin Sonata No.1",
                "catalogue_type": "Op",
                "composition_year_string": "1797-98",
                "composition_year": 1797,
                "key_signature": "d",
                "movements_count": 3,
                "nickname": None,
                "instrumentation": ["violin", "piano"],
                "piece_style": "classical",
            }),
        # Add more test cases as needed
    ]
)
def test_create_piece_from_url(url, expected_data):
    data = create_piece(url=url)
    assert data.catalogue_number == expected_data["catalogue_number"]
    assert data.work_name == expected_data["title"]
    assert data.catalogue_type == expected_data["catalogue_type"]
    assert data.composition_year_string == expected_data["composition_year_string"]
    assert data.composition_year == expected_data["composition_year"]
    assert len(data.movements) == expected_data["movements_count"]
    assert data.key_signature == expected_data["key_signature"]
    assert data.nickname == expected_data["nickname"]
    assert data.instrumentation == expected_data["instrumentation"]
    assert data.piece_style == expected_data["piece_style"]
