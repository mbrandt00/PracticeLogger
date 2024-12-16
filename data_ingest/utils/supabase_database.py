import json
import os
import polars as pl
import psycopg2


class SupabaseDatabase:
    def __init__(self, db=None, user=None, password=None, host=None, port=None):
        self.conn = psycopg2.connect(
            dbname=db or os.getenv("DB_NAME", "postgres"),
            user=user or os.getenv("DB_USER", "postgres"),
            password=password or os.getenv("DB_PASSWORD", "postgres"),
            host=host or os.getenv("DB_HOST", "localhost"),
            port=port or os.getenv("DB_PORT", 54322),
        )
        self.cur = self.conn.cursor()
        self.cur.execute("SET search_path TO imslp, public;")

    def query(self, query):
        self.cur.execute(query)
        return self.cur.fetchall()

    def bulk_insert_from_df(self, df):
        """Insert all pieces and movements from a Polars DataFrame"""
        successful_inserts = 0
        failed_inserts = []

        # Get composer ID function
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
            imslp_url = EXCLUDED.imslp_url,
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
                composer_id = composer_record[0]  # Assuming the id is the first column

                # Parse movements if they're still in string form
                movements = (
                    json.loads(row["movements"])
                    if isinstance(row["movements"], str)
                    else row["movements"]
                )

                # Insert piece with composer_id and get piece_id
                self.cur.execute(
                    piece_insert_sql,
                    (
                        composer_id,  # Add composer_id as first parameter
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
                    ),
                )
                piece_id = self.cur.fetchone()[0]

                # For existing pieces, we might want to clear old movements before inserting new ones
                self.cur.execute(
                    "DELETE FROM imslp.movements WHERE piece_id = %s", (piece_id,)
                )

                # Insert movements for this piece
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

        return successful_inserts, failed_inserts

    def close(self):
        self.cur.close()
        self.conn.close()
