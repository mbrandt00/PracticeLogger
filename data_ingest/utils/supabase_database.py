import os

import psycopg2


class SupabaseDatabase:
    def __init__(self, db=None, user=None, password=None, host=None, port=None):
        # Retrieve credentials securely (e.g., from environment variables)
        print(db, user, password, host, port)
        self.conn = psycopg2.connect(
            dbname=db or os.getenv("DB_NAME", "postgres"),
            user=user or os.getenv("DB_USER", "postgres"),
            password=password or os.getenv("DB_PASSWORD", "postgres"),
            host=host or os.getenv("DB_HOST", "localhost"),
            port=port or os.getenv("DB_PORT", 54322),
        )
        self.cur = self.conn.cursor()

    def query(self, query):
        self.cur.execute(query)
        return self.cur.fetchall()  # Return results for SELECT queries

    def close(self):
        self.cur.close()
        self.conn.close()
