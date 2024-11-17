import pytest
from bs4 import BeautifulSoup

from utils import get_collection_url, get_composer_collection_objects


def test_get_composer_collection_objects():
    url = get_collection_url("Beethoven, Ludwig van")
    collection_objects = get_composer_collection_objects(url)
    assert len(collection_objects) > 200  # pagination
