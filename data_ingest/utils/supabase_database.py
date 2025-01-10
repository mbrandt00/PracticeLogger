import json
import logging
import os
from typing import Dict, List, Optional, Tuple
from urllib.parse import quote, unquote

import polars as pl
import psycopg2
from psycopg2 import errors

logger = logging.getLogger(__name__)

def load_collections_mapping(composer_name: str) -> dict:
    """Load collections mapping for a given composer"""
    # Clean the composer name: lowercase, replace spaces with underscore, remove commas
    clean_name = composer_name.lower().replace(' ', '_').replace(',', '')
    
    # Get path by going up one directory from current file location
    current_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    filename = os.path.join(current_dir, "collections_mapping", f"{clean_name}.json")
    
    logger.info("Looking for collections mapping at: %s", filename)
    
    try:
        with open(filename, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        logger.warning(f"No collections mapping found at {filename}")
        return {}

class SupabaseDatabase:
    def __init__(self, db=None, user=None, password=None, host=None, port=None):
        """Initialize database connection and create necessary tables"""
        self.conn = psycopg2.connect(
            dbname=db or os.getenv("DB_NAME", "postgres"),
            user=user or os.getenv("DB_USER", "postgres"),
            password=password or os.getenv("DB_PASSWORD", "postgres"),
            host=host or os.getenv("DB_HOST", "localhost"),
            port=port or os.getenv("DB_PORT", 54322),
        )
        self.cur = self.conn.cursor()
        self.cur.execute("SET search_path TO imslp, public;")

    def insert_collection(self, name: str, url: str, composer_id: int) -> int:
        """Insert a collection and return its ID"""
        sql = """
        INSERT INTO imslp.collections (name, url, composer_id)
        VALUES (%s, %s, %s)
        ON CONFLICT (url) DO UPDATE SET
            name = EXCLUDED.name,
            composer_id = EXCLUDED.composer_id
        RETURNING id;
        """
        self.cur.execute(sql, (name, url, composer_id))
        return self.cur.fetchone()[0]

    def link_piece_to_collection(self, collection_id: int, piece_id: int):
        """Link a piece to a collection"""
        sql = """
        INSERT INTO imslp.collection_pieces (collection_id, piece_id)
        VALUES (%s, %s)
        ON CONFLICT DO NOTHING;
        """
        self.cur.execute(sql, (collection_id, piece_id))

    def bulk_insert_from_df(self, df: pl.DataFrame) -> Tuple[int, List[Tuple[str, str]]]:
        """Insert all pieces and movements from a Polars DataFrame"""
        successful_inserts = 0
        failed_inserts = []

        # Get unique composer names from the DataFrame
        unique_composers = df.get_column("composer_name").unique().to_list()
        
        # Load all collections mappings at once
        collections_mappings = {}
        for composer_name in unique_composers:
            try:
                collections_mappings[composer_name] = load_collections_mapping(composer_name)
            except Exception as e:
                logger.error(f"Failed to load collections mapping for {composer_name}: {e}")
                collections_mappings[composer_name] = {}

        composer_function_sql = """
        SELECT * FROM public.find_or_create_composer(%s);
        """

        piece_insert_sql = """
        INSERT INTO imslp.pieces (
            composer_id, work_name, catalogue_type_num_desc, catalogue_type,
            catalogue_number, catalogue_number_secondary, composition_year,
            composition_year_string, key_signature, sub_piece_type,
            sub_piece_count, instrumentation, nickname, piece_style,
            imslp_url, wikipedia_url
        ) VALUES (
            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
        )
        ON CONFLICT (imslp_url)
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
            wikipedia_url = EXCLUDED.wikipedia_url
        RETURNING id;
        """

        movement_insert_sql = """
        INSERT INTO imslp.movements (
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
                # First get or create the composer
                self.cur.execute(composer_function_sql, (row["composer_name"],))
                composer_record = self.cur.fetchone()
                composer_id = composer_record[0]

                # Get collections mapping for this composer from the preloaded dictionary
                collections_mapping = collections_mappings.get(row["composer_name"], {})
                
                # Find matching collection for this piece
                piece_url = row["imslp_url"]
                decoded_piece_url = unquote(piece_url)
                encoded_piece_url = quote(decoded_piece_url, safe=':/')
                matching_collection = None

                try:
                    for collection_name, collection_data in collections_mapping.items():
                        encoded_collection_pieces = [quote(url, safe=':/') for url in collection_data["pieces"]]
                        if encoded_piece_url in encoded_collection_pieces:
                            matching_collection = {
                                "name": collection_name,
                                "url": collection_data["url"]
                            }
                            logger.info(f"Found matching collection: {collection_name}")
                            break
                except Exception as e:
                    logger.error(f"Error processing collections for {piece_url}: {e}")
                    matching_collection = None

                # Insert piece and get piece_id
                self.cur.execute(
                    piece_insert_sql,
                    (
                        composer_id,
                        row["work_name"],
                        row["catalogue_desc_str"],
                        row.get("catalogue_type", "").lower() if row.get("catalogue_type") else None,
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
                    ),
                )
                piece_id = self.cur.fetchone()[0]

                # Handle collection association if found
                if matching_collection:
                    try:
                        collection_id = self.insert_collection(
                            matching_collection["name"],
                            matching_collection["url"],
                            composer_id
                        )
                        self.link_piece_to_collection(collection_id, piece_id)
                    except Exception as e:
                        logger.error(f"Failed to link piece to collection: {e}")
                        # Continue processing even if collection linking fails
                
                # Parse and insert movements
                movements = (
                    json.loads(row["movements"])
                    if isinstance(row["movements"], str)
                    else row["movements"]
                )

                # Clear existing movements for this piece
                self.cur.execute(
                    "DELETE FROM imslp.movements WHERE piece_id = %s",
                    (piece_id,)
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
                logger.error(f"Failed to insert piece {row['work_name']}: {e}")
                continue

        return successful_inserts, failed_inserts

    def close(self):
        """Close database connection and cursor"""
        if self.cur:
            self.cur.close()
        if self.conn:
            self.conn.close()
