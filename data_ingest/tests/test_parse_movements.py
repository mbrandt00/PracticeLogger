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
        assert result[0]['key_signature'] == 'c'
        assert result[1]['key_signature'] == 'bflatminor'
        assert result[2]['key_signature'] == 'e'
        assert result[3]['key_signature'] == 'eminor'
        assert result[4]['key_signature'] == 'g'
        assert result[5]['key_signature'] == 'fminor'
        assert result[6]['key_signature'] == 'f'
        assert result[7]['key_signature'] == 'aminor'
        assert result[8]['key_signature'] == 'a'
        assert result[9]['key_signature'] == 'bminor'
        assert result[10]['key_signature'] == 'b'
        assert result[11]['key_signature'] == 'gsharpminor'
        assert result[12]['key_signature'] == 'dflat'
