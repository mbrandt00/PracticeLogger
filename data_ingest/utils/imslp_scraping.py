import json
import logging
import os
import sys
import time
from typing import List, Literal
from urllib.parse import quote, urlparse

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from webdriver_manager.chrome import ChromeDriverManager

from .pieces import create_piece

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))


def get_composer_url(composer_name: str) -> str:
    base_url = "https://imslp.org/wiki/Category:"
    # Encode the composer name correctly using quote
    encoded_name = quote(
        composer_name, safe=","
    )  # This will encode the comma and leave it as '%2C'

    return f"{base_url}{encoded_name}"


def base_imslp_iterator(
    base_url: str,
    tab: Literal[
        "Collections",
        "Compositions",
        "Collaborations",
        "Pasticcios",
        "As Arranger",
        "As Copyist",
        "As Dedicatee",
        "Books",
    ],
) -> List[str]:
    """iterates through an IMSLP compose base_url with filters on tab and returns hrefs"""
    options = Options()
    options.add_argument("--headless")
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()), options=options
    )
    collection_objects = []
    try:
        driver.get(base_url)
        wait = WebDriverWait(driver, 20)

        # Find the tab
        tab_xpath_patterns = [
            f"//a[contains(text(), '{tab}')]",
            f"//a[normalize-space()='{tab}']",
            f"//div[contains(@class, 'tabpanel')]//a[contains(text(), '{tab}')]",
        ]

        collection_link = None
        for xpath in tab_xpath_patterns:
            try:
                collection_link = wait.until(
                    EC.element_to_be_clickable((By.XPATH, xpath))
                )
                break
            except Exception:
                continue

        if not collection_link:
            return []

        # Get the container ID and click the tab
        collection_container_id = urlparse(
            collection_link.get_attribute("href")
        ).fragment

        if not collection_container_id:
            return []

        driver.execute_script("arguments[0].click();", collection_link)
        time.sleep(2)  # Wait for content to load

        # Wait for the specific container to be present
        try:
            container = wait.until(
                EC.presence_of_element_located((By.ID, collection_container_id))
            )
        except Exception:
            return []

        # Function to get links from the current container
        def get_container_links():
            try:
                # Only look for links within the specific container
                container = driver.find_element(By.ID, collection_container_id)
                links = container.find_elements(By.TAG_NAME, "a")
                valid_hrefs = []
                for link in links:
                    href = link.get_attribute("href")
                    if href and "/wiki/" in href:
                        valid_hrefs.append(href)
                return valid_hrefs
            except Exception:
                return []

        # Get initial links
        collection_objects.extend(get_container_links())

        # Handle pagination within the container
        while True:
            try:
                # Look for next page link within the container
                container = driver.find_element(By.ID, collection_container_id)
                next_page = container.find_element(
                    By.XPATH,
                    ".//a[contains(@class, 'categorypaginglink') and contains(text(), 'next') and not(contains(text(), 'no next'))]",
                )
                driver.execute_script("arguments[0].click();", next_page)
                time.sleep(2)

                # Get links from the new page
                new_links = get_container_links()
                if not new_links:
                    break
                collection_objects.extend(new_links)

            except Exception:
                break

    finally:
        driver.quit()

    if not collection_objects:
        print(f"Warning: No hrefs found for {base_url}")
        return []

    return list(set(collection_objects))


def get_all_composer_pieces(base_url: str) -> List[str]:
    return base_imslp_iterator(base_url, tab="Compositions")


def piece_to_dict(new_piece):
    try:
        piece_dict = vars(new_piece).copy()
        piece_dict["movements"] = json.dumps([vars(m) for m in new_piece.movements])
        return piece_dict
    except Exception as e:
        print("ERROR", e)
        print(new_piece)
        raise e


if __name__ == "__main__":
    from pathlib import Path

    file = Path("test_df.parquet")
    # testing
    # if file.is_file():
    #     df = pl.read_parquet(file)
    #     print(df.head(5))
    # else:
    logging.info("pulling data to parquet")
    # composers = ["Beethoven, Ludwig van", "Chopin, Frédéric", "Scriabin, Aleksandr"]
    composers = ["Brahms, Johannes"]
    pieces = []
    for composer in composers:
        url = get_composer_url(composer)
        data = get_all_composer_pieces(url)
        
        for piece_url in data[:100]:
            try:
                piece = create_piece(url=piece_url)
                pieces.append(piece)
            except Exception as e:
                print(e)
            
    pieces_dict = [piece_to_dict(piece) for piece in pieces]
    print(pieces_dict)
    # df = pl.DataFrame(pieces_dict, strict=False)
    # df.write_parquet("test_df.parquet")
    # db = SupabaseDatabase()
    # try:
    #     # Run a query
    #     results = db.cur.execute(
    #         """
    #         CREATE SCHEMA IF NOT EXISTS imslp;
    #         CREATE TABLE IF NOT EXISTS imslp.pieces (
    #             id BIGSERIAL,
    #             work_name varchar,
    #             composer_id BIGINT,
    #             format public.piece_format,
    #             key_signature public.key_signature_type,
    #             catalogue_type public.catalogue_type,
    #             catalogue_number int,
    #             nickname varchar,
    #             catalogue_type_num_desc varchar,
    #             composition_year int,
    #             composition_year_desc int,
    #             piece_style varchar,
    #             wikipedia_url varchar,
    #             instrumentation text[]
    #         );
    #         """
    #     )
    #     db.conn.commit()
    #     # # Fetch results (if needed)
    #     # results = db.query("SELECT * FROM auth.users;")
    #     # print(results)
    # except Exception as e:
    #     print("ERROR", e)
    # finally:
    #     # Ensure the connection is closed
    #     db.close()
    # write_df(df)
    #
    # print("DATA")
    # print(df)
    #
