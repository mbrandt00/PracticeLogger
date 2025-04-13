import json
import logging
import subprocess
from typing import List, Literal, Tuple

import polars as pl
import psycopg2

from .imslp_utils import load_collections_mapping, urls_match

logger = logging.getLogger(__name__)

logger.setLevel(logging.ERROR)
EnvironmentType = Literal["local", "prod"]


def get_db_credentials(env: EnvironmentType) -> dict:
    """Get database credentials from 1Password based on environment"""
    if env == "local":
        return {
            "db": "postgres",
            "user": "postgres",
            "password": "postgres",
            "host": "localhost",
            "port": 54322,
        }

    try:
        # Read from 1Password CLI
        credentials = {}
        fields = ["database", "user", "password", "host", "port"]
        for field in fields:
            result = subprocess.run(
                ["op", "read", f"op://Personal/PracticeLogger/{field}"],
                capture_output=True,
                text=True,
                check=True,
            )
            credentials[field] = result.stdout.strip()

        return {
            "db": credentials["database"],
            "user": credentials["user"],
            "password": credentials["password"],
            "host": credentials["host"],
            "port": int(credentials["port"]),
        }
    except subprocess.CalledProcessError as e:
        logger.error(f"Failed to read from 1Password: {e}")
        raise


class SupabaseDatabase:
    def __init__(self, env: EnvironmentType = "local"):
        """Initialize database connection and create necessary tables

        Args:
            env: Either "local" or "prod" to determine which credentials to use
        """
        credentials = get_db_credentials(env)

        self.conn = psycopg2.connect(
            dbname=credentials["db"],
            user=credentials["user"],
            password=credentials["password"],
            host=credentials["host"],
            port=credentials["port"],
        )
        self.cur = self.conn.cursor()
        # self.cur.execute("SET search_path TO imslp, public;")

    def insert_collection(self, name: str, url: str, composer_id: int) -> int:
        """Insert a collection and return its ID"""
        sql = """
        INSERT INTO collections (name, url, composer_id)
        VALUES (%s, %s, %s)
        ON CONFLICT (name, composer_id)
        DO UPDATE SET
            url = EXCLUDED.url
        RETURNING id;
        """
        self.cur.execute(sql, (name, url, composer_id))
        returned_rec = self.cur.fetchone()
        if returned_rec is None:
            raise ValueError("Collection not inserted correctly")

        return returned_rec[0]

    def bulk_insert_from_df(
        self, df: pl.DataFrame
    ) -> Tuple[int, List[Tuple[str, str]]]:
        """Insert all pieces and movements from a Polars DataFrame"""
        successful_inserts = 0
        failed_inserts = []

        composer_function_sql = """
        SELECT * FROM public.find_or_create_composer(%s);
        """

        piece_insert_sql = """
        INSERT INTO pieces (
            user_id, composer_id, work_name, catalogue_type_num_desc, catalogue_type,
            catalogue_number, catalogue_number_secondary, composition_year,
            composition_year_string, key_signature, sub_piece_type,
            sub_piece_count, instrumentation, nickname, piece_style,
            imslp_url, wikipedia_url, collection_id, format
        ) VALUES (
            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
        )
        ON CONFLICT (imslp_url, user_id)
        DO UPDATE SET
            work_name = EXCLUDED.work_name,
            catalogue_type_num_desc = EXCLUDED.catalogue_type_num_desc,
            catalogue_number_secondary = EXCLUDED.catalogue_number_secondary,
            composition_year = EXCLUDED.composition_year,
            composition_year_string = EXCLUDED.composition_year_string,
            key_signature = EXCLUDED.key_signature,
            sub_piece_type = EXCLUDED.sub_piece_type,
            sub_piece_count = EXCLUDED.sub_piece_count,
            instrumentation = EXCLUDED.instrumentation,
            nickname = EXCLUDED.nickname,
            piece_style = EXCLUDED.piece_style,
            wikipedia_url = EXCLUDED.wikipedia_url,
            collection_id = EXCLUDED.collection_id,
            format = EXCLUDED.format
        RETURNING id;
        """

        movement_insert_sql = """
        INSERT INTO movements (
            piece_id, 
            name,
            number,
            key_signature,
            download_url,
            nickname
        ) VALUES (
            %s, %s, %s, %s, %s, %s
        );
        """

        for row in df.iter_rows(named=True):
            try:
                self.cur.execute(composer_function_sql, (row["composer_name"],))
                composer_record = self.cur.fetchone()
                if composer_record is None:
                    raise ValueError(f"Could not find composer in supabase (id: {row})")
                composer_id = composer_record[0]

                composer_collections = load_collections_mapping(row["composer_name"])

                collection_id = None

                if composer_collections:
                    # Try to find a matching collection
                    for (
                        collection_name,
                        collection_data,
                    ) in composer_collections.items():
                        logger.info(collection_name, collection_data)
                        for piece_url in collection_data["pieces"]:
                            if urls_match(row["imslp_url"], piece_url):
                                # Insert collection and get its ID
                                collection_id = self.insert_collection(
                                    collection_name, collection_data["url"], composer_id
                                )
                                logger.info(
                                    f"Matched piece {row['work_name']} to collection {collection_name}"
                                )
                                break
                        if collection_id:
                            break

                self.cur.execute(
                    piece_insert_sql,
                    (
                        None,
                        composer_id,
                        row["work_name"],
                        row["catalogue_desc_str"],
                        row.get("catalogue_type", "").lower()
                        if row.get("catalogue_type")
                        else None,
                        row["catalogue_number"],
                        row["catalogue_number_secondary"],
                        row["composition_year"],
                        row["composition_year_string"],
                        row["key_signature"],
                        row["sub_piece_type"],
                        row["sub_piece_count"],
                        row["instrumentation"],
                        row["nickname"],
                        row["piece_style"],
                        row["imslp_url"],
                        row["wikipedia_url"],
                        collection_id,
                        row["format"] if row.get("format") else None,
                    ),
                )
                inserted_id = self.cur.fetchone()
                if inserted_id is None:
                    raise ValueError(f"Piece not inserted correctly {row}")
                piece_id = inserted_id[0]

                movements = (
                    json.loads(row["movements"])
                    if isinstance(row["movements"], str)
                    else row["movements"]
                )

                self.cur.execute(
                    "DELETE FROM movements WHERE piece_id = %s", (piece_id,)
                )

                for movement in movements:
                    self.cur.execute(
                        movement_insert_sql,
                        (
                            piece_id,
                            movement["title"],
                            movement["number"],
                            movement.get("key_signature"),
                            movement.get("download_url"),
                            movement.get("nickname"),
                        ),
                    )

                self.conn.commit()
                successful_inserts += 1

            except Exception as e:
                self.conn.rollback()
                failed_inserts.append((row["work_name"], str(e)))
                continue
        logger.info("Refreshing all searchable text")
        self.cur.execute("SELECT refresh_all_searchable_text();")
        self.conn.commit()
        return successful_inserts, failed_inserts

    def close(self):
        """Close database connection and cursor"""
        if self.cur:
            self.cur.close()
        if self.conn:
            self.conn.close()
