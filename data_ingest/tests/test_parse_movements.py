import pytest
from bs4 import BeautifulSoup

from utils import parse_movements


def test_parse_piece_sections():
    with open("tests/scrape_responses/rachmaninoff_preludes_op_32.html", "r") as file:
        html_content = file.read()
        soup = BeautifulSoup(html_content, "html.parser")
        result = parse_movements(soup)
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

        # url
        print(result)
        assert result[0]['download_url'] == 'https://imslp.org/wiki/Special:ImagefromIndex/309270'
        assert result[1]['download_url'] == 'https://imslp.org/wiki/Special:ImagefromIndex/309271'

def test_parse_piece_movements():
    with open('tests/scrape_responses/chopin_cello_sonata.html') as file:
        html_content = file.read()
        soup = BeautifulSoup(html_content, "html.parser")
        result = parse_movements(soup)
        assert result[0]['key_signature'] == 'gminor'
        assert result[1]['key_signature'] == 'dminor'
        # number
        assert result[0]['number'] == 1
        assert result[1]['number'] == 2
        # clean name without number
        assert result[0]['name'] == 'Allegro moderato'
        assert result[1]['name'] == 'Scherzo'

        # url
        print(result)
        assert result[0]['download_url'] is None
        assert result[1]['download_url'] is None
