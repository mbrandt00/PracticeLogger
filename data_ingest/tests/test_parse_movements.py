import pytest
from bs4 import BeautifulSoup

from utils.movements import parse_key_signature, parse_movements


def test_parse_piece_movements():
    result = parse_movements(
        url="https://imslp.org/wiki/Cello_Sonata,_Op.65_(Chopin,_Fr%C3%A9d%C3%A9ric)"
    )
    assert result[0].key_signature == "gminor"
    assert result[1].key_signature == "dminor"
    # number
    assert result[0].number == 1
    assert result[1].number == 2
    # clean name without number
    assert result[0].title == "Allegro moderato"
    assert result[1].title == "Scherzo"


@pytest.mark.parametrize(
    "test_input,expected",
    [
        ("C ♯", "csharp"),
        ("D ♭", "dflat"),
        ("E♯", "esharp"),
        ("C flat", "cflat"),
        ("E-flat major", "eflat"),
        ("Presto  = 192-200 (D♭ major)", "dflat"),
        (
            "D<span class=\"music-symbol\" style='font-family: Arial Unicode MS, Lucida Sans Unicode; font-size:110%'>♭</span> major)",
            "dflat",
        ),
    ],
)
def test_parse_key_signature(test_input, expected):
    assert parse_key_signature(test_input) == expected


class TestParseMovements:
    def test_parse_piece_sections(self):
        result = parse_movements(
            url="https://imslp.org/wiki/13_Preludes,_Op.32_(Rachmaninoff,_Sergei)"
        )
        assert isinstance(result, list)
        # key signature
        assert result[0].key_signature == "c"
        assert result[1].key_signature == "bflatminor"
        # number
        assert result[0].number == 1
        assert result[1].number == 2
        # clean name without number
        assert result[0].title == "Allegro vivace"
        assert result[1].title == "Allegretto"
        # url
        print(result)
        assert (
            result[0].download_url
            == "https://imslp.org/wiki/Special:ImagefromIndex/309270"
        )
        assert (
            result[1].download_url
            == "https://imslp.org/wiki/Special:ImagefromIndex/309271"
        )


def test_create_piece_with_sub_piece_and_nickname():
    data = parse_movements(
        url="https://imslp.org/wiki/%C3%89tudes,_Op.25_(Chopin,_Fr%C3%A9d%C3%A9ric)"
    )
    print(data)
    assert len(data) == 12
    assert data[0].nickname == "Aeolian Harp"
    assert data[1].nickname == "The Bees"
    assert data[2].nickname == "The Horseman"
    assert data[3].nickname == "Paganini"
    assert data[4].nickname == "Wrong Note"
    assert data[5].nickname == "Thirds"
    assert data[6].nickname == "Cello"

    assert data[0].key_signature == "aflat"
    assert data[1].key_signature == "fminor"
    assert data[2].key_signature == "f"
    assert data[3].key_signature == "aminor"
    assert data[4].key_signature == "eminor"
    assert data[5].key_signature == "gsharpminor"
    assert data[6].key_signature == "csharpminor"
