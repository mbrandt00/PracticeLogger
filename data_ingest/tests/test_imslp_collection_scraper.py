import pytest

from utils.imslp_scraping import get_composer_collection_objects, get_composer_url


@pytest.mark.skip
def test_get_composer_collection_objects():
    url = get_composer_url("Beethoven, Ludwig van")
    collection_objects = get_composer_collection_objects(url)
    assert len(collection_objects) > 200  # pagination


def test_collection_to_pieces():
    with open("tests/scrape_responses/beethoven_collection_urls.txt", "r") as file:
        urls = [line.strip() for line in file.readlines()]
        print(urls)
