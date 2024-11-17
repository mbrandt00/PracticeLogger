import pytest
from bs4 import BeautifulSoup

from utils import get_composer_collection_objects


def test_getcomposer_collection_objects():
    with open("tests/scrape_responses/beethoven_collections_view.html", "r") as file:
        html_content = file.read()
        soup = BeautifulSoup(html_content, "html.parser")
        collection = get_composer_collection_objects(soup)

    assert collection is True
