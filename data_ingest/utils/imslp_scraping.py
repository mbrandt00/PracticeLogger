import os
import sys
import time
from typing import List
from urllib.parse import quote, urlparse

import requests
from bs4 import BeautifulSoup
from pieces import create_piece
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from webdriver_manager.chrome import ChromeDriverManager

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

def get_collection_url(composer_name: str) -> str:
    base_url = "https://imslp.org/wiki/Category:"
    # Encode the composer name correctly using quote
    encoded_name = quote(
        composer_name, safe=","
    )  # This will encode the comma and leave it as '%2C'

    return f"{base_url}{encoded_name}"


def get_composer_collection_objects(base_url: str) -> List[str]:
    options = Options()
    options.add_argument("--headless")
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()), options=options
    )
    try:
        # Open the URL directly in Selenium
        driver.get(base_url)
        wait = WebDriverWait(
            driver, 10
        )  # Initialize wait object with 10 second timeout
        collection_objects = []

        # Find and click the Collections link
        collection_link = wait.until(
            EC.element_to_be_clickable(
                (By.XPATH, "//a[contains(text(), 'Collections')]")
            )
        )
        collection_container_id = urlparse(
            collection_link.get_attribute("href")
        ).fragment
        driver.execute_script("arguments[0].click();", collection_link)

        # Wait for the initial collection content to load
        if collection_container_id and isinstance(collection_container_id, str):
            wait.until(EC.presence_of_element_located((By.ID, collection_container_id)))

        while True:
            try:
                # Wait for the collection links to be present
                wait.until(
                    EC.presence_of_all_elements_located(
                        (
                            By.CSS_SELECTOR,
                            f"#{collection_container_id} a.categorypagelink",
                        )
                    )
                )

                # Get the current page's links
                links = driver.find_elements(
                    By.CSS_SELECTOR, f"#{collection_container_id} a.categorypagelink"
                )

                # Extract hrefs
                for link in links:
                    href = link.get_attribute("href")
                    if href:
                        collection_objects.append(href)

                # Look for the next page link
                try:
                    next_page = wait.until(
                        EC.presence_of_element_located(
                            (
                                By.XPATH,
                                "//a[contains(@class, 'categorypaginglink') and contains(text(), 'next') and not(contains(text(), 'no next'))]",
                            )
                        )
                    )

                    # Use JavaScript click instead of regular click
                    driver.execute_script("arguments[0].click();", next_page)

                    # Wait for the page content to update
                    time.sleep(1)  # Short sleep to allow for any animations

                    # Wait for the content to change
                    # We can do this by waiting for the staleness of one of the current links
                    if links:
                        try:
                            wait.until(EC.staleness_of(links[0]))
                        except Exception:
                            pass

                except Exception:
                    break

            except Exception:
                break

    finally:
        driver.quit()

    return list(set(collection_objects))

def create_piece_collection(url: str): 
    data = requests.get(url)
    soup = BeautifulSoup(data.text, 'html.parser')
    tables = soup.find_all('table')
    second_table = tables[1] if len(tables) > 1 else None
    if second_table:
        piece_count_text = second_table.find('td').text
        links = soup.select('tr td ul li a[title]')
        if not links:
            raise ValueError("No piece urls found for collection")
        base_url = "https://imslp.org"

        urls = [base_url + str(link['href']) for link in links if 'href' in link.attrs]
        for piece_url in urls:
            data = requests.get(piece_url)
            piece_soup = BeautifulSoup(data.text, 'html.parser')
            test = create_piece(piece_soup)
            print(test)

        # print(links)

create_piece_collection('https://imslp.org/wiki/Complete_Piano_Sonatas_(Beethoven%2C_Ludwig_van)')
