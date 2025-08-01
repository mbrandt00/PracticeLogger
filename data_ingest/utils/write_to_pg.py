import argparse
import glob
import logging
import os
from pathlib import Path

import polars as pl

from .supabase_database import SupabaseDatabase

parser = argparse.ArgumentParser(description="Process data with environment selection")
parser.add_argument(
    "--env",
    choices=["prod", "local"],
    default="local",
    help="Environment to use (prod or local)",
)
args = parser.parse_args()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)

# Find most recent file matching pattern
pattern = "full_df_*.parquet"
script_dir = os.path.dirname(os.path.abspath(__file__))
parquet_dir = os.path.join(script_dir, "..", "parquet")
search_path = os.path.join(parquet_dir, pattern)

try:
    files = glob.glob(search_path)
    if not files:
        logger.error(f"No files found matching pattern: {search_path}")
        raise FileNotFoundError(f"No files found matching pattern: {search_path}")

    latest_file = max(files, key=os.path.getctime)  # Get most recent file
    logger.info(f"Reading from most recent file: {latest_file}")

    df = pl.read_parquet(Path(latest_file))
    logger.info(f"Successfully loaded DataFrame with shape: {df.shape}")
except Exception as e:
    logger.error(f"Error reading parquet file: {e}")
    raise

logger.info("Starting data filtering and processing")

print("filtering out records with catalogue count less than 30")
catalogue_counts = (
    df.group_by("catalogue_type")
    .agg(pl.len().alias("catalogue_count"))
    .filter(pl.col("catalogue_count") >= 30)
)

# Join back to main dataframe to keep only records with common catalogue types
df = df.join(
    catalogue_counts.select("catalogue_type"), on="catalogue_type", how="inner"
).filter(
    # Keep nulls as well since they are common in your data
    pl.col("catalogue_type").is_null()
    | pl.col("catalogue_type").is_in(catalogue_counts["catalogue_type"])
)

filtered_df = (
    df.group_by("composer_name")
    .agg(pl.count("work_name").alias("count"))
    .filter(pl.col("count") > 10)
    .join(df, on="composer_name")
)

logger.info(f"After initial filtering and join, DataFrame shape: {filtered_df.shape}")

filtered_df.schema
print(filtered_df.count())
print("HEAD")
print(df.head(1))
filtered_df = filtered_df.filter(
    pl.when(pl.col("instrumentation").list.len() > 0)
    .then(
        ~pl.col("instrumentation").list.first().str.contains("chorus|SATB|mixed chorus")
    )
    .otherwise(True)
)

logger.info("Applied chorus/SATB filtering")

instrument_mapping = {
    "viol": "violin",
    "piano)": "piano",
    "(piano": "piano",
    "Piano Solo": "piano",
    "1 piano": "piano",
    "piano (no.12 = 2 voices": "piano",
    "piano (or harp (no.7 only)": "piano",
    "piano (nos.5-7)": "piano",
    "piano (arranged)": "piano",
    "2 horns)": "2 horns",
}

filtered_df = filtered_df.with_columns(
    pl.col("instrumentation")
    .list.eval(
        pl.when(pl.element().str.to_lowercase().is_in(instrument_mapping.keys()))
        .then(pl.element().str.to_lowercase().replace(instrument_mapping))
        .otherwise(pl.element().str.to_lowercase())
    )
    .alias("instrumentation")
)

logger.info("Applied instrument mapping transformations")

unique_instruments = (
    filtered_df.select("instrumentation", "work_name", "composer_name", "imslp_url")
    .explode("instrumentation")
    .unique()
    .sort(by="work_name")
)

logger.info(
    f"Created unique instruments DataFrame with shape: {unique_instruments.shape}"
)

df = filtered_df.unique()
composer_names = (
    df.select("composer_name").unique().sort("composer_name").to_series().to_list()
)
print(composer_names)
df = df.filter(pl.col("composer_name") == "Balakirev, Mily")
raise ValueError(df.height)
db = SupabaseDatabase(env=args.env)
try:
    logger.info("Starting database insertion")
    successful, failed = db.bulk_insert_from_df(df)
    if failed:
        logger.warning(f"Failed to insert {len(failed)} pieces")
        for work_name, error in failed:
            logger.error(f"Insert failed for '{work_name}': {error}")
except Exception as e:
    logger.error(f"Database operation failed: {e}")
    raise
finally:
    logger.info("Closing database connection")
    db.close()
