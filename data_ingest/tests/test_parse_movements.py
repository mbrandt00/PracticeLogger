import pytest
from bs4 import BeautifulSoup

from utils import parse_key_signature, parse_movements


@pytest.mark.parametrize("test_input,expected", [
    ("C ♯", "csharp"),
    ("D ♭", "dflat"),
    ("E♯", "esharp"),
    ("C flat", "cflat"),
    ("D<span class=\"music-symbol\" style='font-family: Arial Unicode MS, Lucida Sans Unicode; font-size:110%'>♭</span> major)", "dflat"),

])
def test_parse_key_signature(test_input, expected):
    assert parse_key_signature(test_input) == expected

def test_parse_movements():
    with open("tests/scrape_responses/rachmaninoff_preludes_op_32.html", "r") as file:
        html_content = file.read()
        soup = BeautifulSoup(html_content, "html.parser")
        general_info_div = soup.find("div", class_="wi_body")
        if general_info_div is None:
            raise ValueError("Could not find 'div' with class 'wi_body'")
        result = parse_movements(general_info_div)
        assert isinstance( result, list)
        # key signature
        assert result[0]['key_signature'] == 'c'
        assert result[1]['key_signature'] == 'bflatminor'
        # number
        assert result[0]['number'] == 1
        assert result[1]['number'] == 2
        # clean name without number
        assert result[0]['name'] == 'Allegro vivace'
        assert result[1]['name'] == 'Allegretto'
