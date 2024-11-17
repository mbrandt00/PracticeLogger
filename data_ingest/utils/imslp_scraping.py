import time
from typing import List
from urllib.parse import quote, urlparse

import requests
from bs4 import BeautifulSoup, Tag
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager


def get_collection_page(composer_name: str) -> BeautifulSoup:
    base_url = "https://imslp.org/wiki/Category:"
    # Encode the composer name correctly using quote
    encoded_name = quote(composer_name, safe=",")  # This will encode the comma and leave it as '%2C'
    
    full_url = f"{base_url}{encoded_name}"
    response = requests.get(full_url)
    response.raise_for_status()  # Ensure successful request
    
    return BeautifulSoup(response.text, 'html.parser')


def get_composer_collection_objects(base_url: str) -> List[str]:
    options = Options()
    options.add_argument('--headless')  # Run in headless mode (no browser UI)
    driver = webdriver.Chrome( 
    service=Service(
        ChromeDriverManager().install()
    ),
    options=options
)

    # Open the URL directly in Selenium
    driver.get(base_url)

    collection_objects = []
    try:
        collection_link = driver.find_element(
            By.XPATH, "//a[contains(text(), 'Collections')]"
        )

        # Scroll to the element (optional, if the element is out of view)
        ActionChains(driver).move_to_element(collection_link).perform()

        print(f"COLLECTION LINK: {collection_link}")
        # Click the collection link
        collection_container_id = urlparse(collection_link.get_attribute('href')).fragment


        print(collection_container_id)
        collection_link.click()

        # Wait for the new content to load after clicking
        time.sleep(1)

        page_source = driver.page_source
        soup = BeautifulSoup(page_source, 'html.parser')
        links = soup.find(id=collection_container_id)
        if isinstance(links, Tag):
            links = links.find_all('a', class_ = "categorypagelink")
            for link in links:
                href = link.get('href')
                if href: 
                    collection_objects.append(href)
        else: 
            print('not found')
        print(collection_objects)

    except Exception as e:
        print(f"Error: {e}")

    driver.quit()

    return collection_objects


# # Example usage:
# composer_name = "Beethoven, Ludwig van"  # Replace with the composer you're looking for
# soup = get_collection_page(composer_name)
url = 'https://imslp.org/wiki/Category:Beethoven,_Ludwig_van'
collection_objects = get_composer_collection_objects(url)

# Print out the collection objects for debugging


