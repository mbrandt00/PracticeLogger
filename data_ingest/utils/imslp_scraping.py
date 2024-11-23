import logging
import os
import sys
import time
from typing import List, Literal, Optional, Union
from urllib.parse import quote, urlparse

import polars as pl
import requests
from bs4 import BeautifulSoup
from pieces import Piece, create_piece
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from supabase_database import SupabaseDatabase
from webdriver_manager.chrome import ChromeDriverManager

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
        # Open the URL directly in Selenium
        driver.get(base_url)
        wait = WebDriverWait(
            driver, 10
        )  # Initialize wait object with 10 second timeout

        # Find and click the Collections link
        collection_link = wait.until(
            EC.element_to_be_clickable((By.XPATH, f"//a[contains(text(), '{tab}')]"))
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

    if not collection_objects: 
        raise ValueError("No hrefs found")

    return list(set(collection_objects))


def get_all_composer_pieces(base_url: str) -> List[str]:
    return base_imslp_iterator(base_url, tab="Compositions")


def get_composer_collection_objects(base_url: str) -> List[str]:
    return base_imslp_iterator(base_url, tab="Collections")


# def create_table_from_dataclass(dataclass, schema, table_name):
#     columns = []
#     for field in dataclass.__annotations__.items():
#         name, typ = field
#         # Mapping Python types to SQL types
#         if typ is int:
#             columns.append(f"{name} INT")
#         elif typ is str:
#             columns.append(f"{name} VARCHAR(255)")
#         elif typ is Optional[int]:
#             columns.append(f"{name} INT")  # Assuming INT for Optional[int]
#         elif typ is Optional[str]:
#             columns.append(f"{name} VARCHAR(255)")  # Assuming VARCHAR for Optional[str]
#         else:
#             columns.append(f"{name} VARCHAR(255)")  # Default to VARCHAR
#     columns_sql = ", ".join(columns)
#     create_statement = (
#         f"CREATE TABLE IF NOT EXISTS {schema}.{table_name} ({columns_sql});"
#     )
#     return create_statement


# need to add id to pieces, movements

if __name__ == "__main__":
    url = get_composer_url("Beethoven, Ludwig van")
    data = get_all_composer_pieces(url)
    pieces = []
    for piece_url in data[:5]:
        piece = create_piece(url=piece_url)
        piece.imslp_url = piece_url
        pieces.append(piece)
    df = pl.DataFrame(pieces)
    print(df.columns)
    print(df.select('imslp_url').head(5))
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


