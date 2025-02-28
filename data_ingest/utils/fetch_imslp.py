import argparse
import datetime
import json
import logging
import os
import time

import polars as pl

from .imslp_scraping import get_all_composer_pieces, get_composer_url
from .pieces import create_piece

# Add argument parsing at the top
parser = argparse.ArgumentParser(description='IMSLP web scraper for composer pieces')
parser.add_argument('--debug', 
                   action='store_true',
                   help='Run in debug mode with limited composer set')

args = parser.parse_args()
log_dir = "logs"
os.makedirs(log_dir, exist_ok=True)

# Generate log filename with timestamp
current_time = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
log_file = os.path.join(log_dir, f"imslp_scraper_{current_time}.log")

# Configure logging to both file and console
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=[
        logging.FileHandler(log_file),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

DEBUG_COMPOSERS = [
    "Rachmaninoff, Sergei",
    "Chopin, Frédéric",
]

composers = [
    "Bach, Johann Sebastian",
    "Mozart, Wolfgang Amadeus",
    "Prokofiev, Sergey",
    "Liszt, Franz",
    "Debussy, Claude",
    "Tchaikovsky, Pyotr",
    "Schumann, Robert",
    "Shostakovich, Dmitry",
    "Mendelssohn, Felix",
    "Schubert, Franz",
    "Dvořák, Antonín",
    "Grieg, Edvard",
    "Ravel, Maurice",
    "Mahler, Gustav",
    "Ginastera, Alberto",
    "Mussorgsky, Modest",
    "Sibelius, Jean",
    "Haydn, Joseph",
    "Saint-Saëns, Camille",
    "Satie, Erik",
    "Handel, George Frideric",
    "Scarlatti, Domenico",
    "Vivaldi, Antonio",
    "Clementi, Muzio",
    "Couperin, François",
    "Brahms, Johannes",
    "Schumann, Clara",
    "Franck, César",
    "Wagner, Richard",
    "Verdi, Giuseppe",
    "Bruckner, Anton",
    "Berlioz, Hector",
    "Albéniz, Isaac",
    "Fauré, Gabriel",
    "Strauss, Richard",
    "Bartók, Béla",
    "Stravinsky, Igor",
    "Gershwin, George",
    "Poulenc, Francis",
    "Copland, Aaron",
    "Granados, Enrique",
    "Medtner, Nikolay",
    "Bach, Carl Philipp Emanuel",
    "Weber, Carl Maria von",
    "Hummel, Johann Nepomuk",
    "Paganini, Niccolò",
    "Field, John",
    "Balakirev, Mily",
    "Borodin, Aleksandr",
    "Rimsky-Korsakov, Nikolay",
    "Glazunov, Aleksandr",
    "Chausson, Ernest",
    "Smetana, Bedřich",
    "Bizet, Georges",
    "Offenbach, Jacques",
    "Massenet, Jules",
    "Busoni, Ferruccio",
    "Ives, Charles",
    "Schoenberg, Arnold",
    "Berg, Alban",
    "Milhaud, Darius",
    "Hindemith, Paul",
    "Vaughan Williams, Ralph",
    "Elgar, Edward",
    "Britten, Benjamin",
    "Janáček, Leoš",
    "Nielsen, Carl",
    "Bernstein, Leonard",
    "Glinka, Mikhail",
    "Godowsky, Leopold",
    "Lully, Jean-Baptiste",
    "Ligeti, György",
    "Webern, Anton",
    "Beethoven, Ludwig van",
    "Rachmaninoff, Sergei",
    "Chopin, Frédéric",
    "Scriabin, Aleksandr",
]

composers = DEBUG_COMPOSERS if args.debug else composers

pieces = []
total_urls = 0  # Track total number of pieces we expect to process

for composer in composers:
    logger.info("Starting import for %s", composer)
    try:
        url = get_composer_url(composer)
        data = get_all_composer_pieces(url)
        total_urls += len(data)
        
        for piece_url in data:
            if len(pieces) % 100 == 0:
                logger.info(f"Processed {len(pieces)} pieces out of {total_urls} for {composer}")
            
            max_retries = 3
            retry_delay = 2
            
            for attempt in range(max_retries):
                try:
                    piece = create_piece(url=piece_url)
                    if piece:  
                        pieces.append(piece)
                    break  
                except ValueError as e:
                    logger.error("Error processing %s: %s", piece_url, e)
                    if attempt < max_retries - 1:
                        logger.info(f"Retrying in {retry_delay} seconds...")
                        time.sleep(retry_delay)
                except Exception as e:  
                    logger.error(f"Unexpected error processing {piece_url}: {str(e)}")
                    if attempt < max_retries - 1:
                        logger.info(f"Retrying in {retry_delay} seconds...")
                        time.sleep(retry_delay)
                
    except Exception as e:
        logger.error(f"Error processing composer {composer}: {str(e)}")
        continue

if not pieces:
    logger.error("No pieces were collected. Exiting without saving.")
    exit(1)

pieces_dict = []
for piece in pieces:
    if piece is not None:
        piece_dict = vars(piece).copy()
        # Handle the enum format field by converting to string
        if piece_dict["format"] is not None:
            piece_dict["format"] = piece_dict["format"].value  # Convert enum to its value
        
        piece_dict["movements"] = json.dumps([vars(m) for m in piece.movements])
        if piece_dict["instrumentation"] is None:
            piece_dict["instrumentation"] = []
        pieces_dict.append(piece_dict)

if pieces_dict: 
    df = pl.DataFrame(pieces_dict, strict=False, infer_schema_length=1000)
    
    # Print schema to see what we're dealing with
    logger.info("Initial schema: %s", df.schema)
    
    # Convert Object type columns to appropriate types
    for col_name, dtype in df.schema.items():
        if dtype == pl.Object:
            if col_name == "instrumentation":
                df = df.with_columns(pl.col(col_name).cast(pl.List(pl.Utf8)))
            else:
                df = df.with_columns(pl.col(col_name).cast(pl.Utf8))
    
    logger.info("Final schema after type conversion: %s", df.schema)
    
    current_datetime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = f"full_df_{current_datetime}.parquet"
    os.makedirs(os.path.join(os.getcwd(), 'parquet'), exist_ok=True)
    full_path = os.path.join(os.getcwd(), 'parquet', output_file)
    
    df.write_parquet(full_path)
    logger.info("Data saved to %s", full_path)
else:
    logger.error("No valid pieces to save")

# os.system("pmset sleepnow")
