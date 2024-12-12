import polars as pl
from pathlib import Path 
import logging
import glob
import os
from supabase_database import SupabaseDatabase

# Configure logging
logging.basicConfig(
   level=logging.INFO,
   format='%(asctime)s - %(levelname)s - %(message)s',
   datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)

# Find most recent file matching pattern
pattern = "full_df_*.parquet"
try:
   files = glob.glob(pattern)
   if not files:
       logger.error(f"No files found matching pattern: {pattern}")
       raise FileNotFoundError(f"No files found matching pattern: {pattern}")
   
   latest_file = max(files, key=os.path.getctime)  # Get most recent file
   logger.info(f"Reading from most recent file: {latest_file}")
   
   df = pl.read_parquet(Path(latest_file))
   logger.info(f"Successfully loaded DataFrame with shape: {df.shape}")

except Exception as e:
   logger.error(f"Error reading parquet file: {e}")
   raise

logger.info("Starting data filtering and processing")

filtered_df = (
   df.group_by("composer_name")
   .agg(pl.count("work_name").alias("count"))
   .filter(pl.col("count") > 10)
   .join(df, on="composer_name")
)

logger.info(f"After initial filtering and join, DataFrame shape: {filtered_df.shape}")

pl.Config.set_fmt_str_lengths(50)
pl.Config.set_tbl_rows(50)

filtered_df = filtered_df.filter(
   ~(pl.col("instrumentation").list.get(0).str.contains("chorus|SATB|mixed chorus"))
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

logger.info(f"Created unique instruments DataFrame with shape: {unique_instruments.shape}")

df = filtered_df.unique()
logger.info(f"Final DataFrame shape before database insertion: {df.shape}")

db = SupabaseDatabase()
try:
   logger.info("Starting database insertion")
   successful, failed = db.bulk_insert_from_df(df)
   logger.info(f"Successfully inserted {successful} pieces")
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