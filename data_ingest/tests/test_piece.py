import pytest
from bs4 import BeautifulSoup
from typing import List
from utils.pieces import create_piece, parse_metadata
from utils.movements import Movement


def test_parse_metadata():
    sample_data = {
        "Incipit": "movements:1:2:3 (minuet):3 (trio):4:",
        "Movements/SectionsMov'ts/Sec's": "4 movements",
        "year_date_of_composition_y_d_of_comp": "1793-95",
        "Work Title": "Test name",
    }
    # print(type(sample_data))
    parsed = parse_metadata(sample_data)
    keys_to_check = ["composition_year"]

    assert all(key in parsed for key in keys_to_check)
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
                "sub_piece_type": "movements",
                "sub_piece_count": 4,
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
                "sub_piece_type": "movements",
                "sub_piece_count": 3,
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
    assert data.sub_piece_type == expected_data["sub_piece_type"]
    assert data.sub_piece_count == expected_data["sub_piece_count"]


@pytest.mark.parametrize(
    "url, expected_data",
    [
        (
            "https://imslp.org/wiki/Violin_Sonata_No.1%2C_Op.12_No.1_(Beethoven%2C_Ludwig_van)",
            {
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
                "catalogue_number_secondary": 1,
            },
        ),
        (
            "https://imslp.org/wiki/Scherzo_No.1%2C_Op.20_(Chopin%2C_Fr%C3%A9d%C3%A9ric)",
            {
                "catalogue_number": 20,
                "title": "Scherzo No.1",
                "catalogue_type": "Op",
                "composition_year_string": "1833",
                "composition_year": 1833,
                "key_signature": "bminor",
                "movements_count": 0, # no movements here
                "nickname": None,
                "instrumentation": ["piano"],
                "piece_style": "romantic",
                "catalogue_number_secondary": None,

            },
        ),
        (
            "https://imslp.org/index.php?title=Scherzo_No.3%2C_Op.39_%28Chopin%2C_Fr%C3%A9d%C3%A9ric%29",
            {
                "catalogue_number": 39,
                "title": "Scherzo No.3",
                "catalogue_type": "Op",
                "composition_year_string": "1839",
                "composition_year": 1839,
                "key_signature": "csharpminor",
                "movements_count": 0, # no movements here
                "nickname": None,
                "instrumentation": ["piano"],
                "piece_style": "romantic",
                "catalogue_number_secondary": None
            },
        ),
    ],
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
    assert data.catalogue_number_secondary == expected_data["catalogue_number_secondary"]


def test_create_piece_with_sub_pieces():
    data = create_piece(
        url="https://imslp.org/wiki/Mazurkas,_Op.6_(Chopin,_Fr%C3%A9d%C3%A9ric)"
    )  # Chopin op 6 mazurkas
    assert data.sub_piece_type == "pieces"
    assert data.sub_piece_count == 4
