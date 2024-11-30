import pytest

from utils.imslp_scraping import (get_all_composer_pieces,
                                  get_composer_collection_objects,
                                  get_composer_url)


# @pytest.mark.skip
def test_get_composer_collection_objects():
    url = get_composer_url("Mendelssohn, Felix")
    collection_objects = get_all_composer_pieces(url)
    assert len(collection_objects) == 246  # pagination


def test_collection_to_pieces():
    with open("tests/scrape_responses/beethoven_collection_urls.txt", "r") as file:
        urls = [line.strip() for line in file.readlines()]
        print(urls)
