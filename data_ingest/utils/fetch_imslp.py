import datetime
import json
import logging
import os
import time

import polars as pl
from imslp_scraping import get_all_composer_pieces, get_composer_url
from pieces import create_piece

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
    "Telemann, Georg Philipp",
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

pieces = []
for composer in composers:
    logger.info("Starting import for %s", composer)
    try:
        url = get_composer_url(composer)
        data = get_all_composer_pieces(url)
        
        for piece_url in data:
            if len(pieces) % 100 == 0:
                logger.info("Processed %s pieces", len(pieces))
            
            max_retries = 3
            retry_delay = 15
            
            for attempt in range(max_retries):
                try:
                    piece = create_piece(url=piece_url)
                    if piece:  
                        pieces.append(piece)
                    break  
                except ValueError as e:
                    logger.error("Error processing %s: %s", piece_url, e)
                    if attempt < max_retries - 1:  # Don't sleep on the last attempt
                        logger.info(f"Retrying in {retry_delay} seconds...")
                        time.sleep(retry_delay)
                    continue
                except Exception as e:  
                    logger.error(f"Unexpected error processing {piece_url}: {str(e)}")
                    if attempt < max_retries - 1:
                        logger.info(f"Retrying in {retry_delay} seconds...")
                        time.sleep(retry_delay)
                    continue
                
    except Exception as e:
        logger.error(f"Error processing composer {composer}: {str(e)}")
        continue  # Move to next composer if there's an error

if not pieces:
    logger.error("No pieces were collected. Exiting without saving.")
    exit(1)

pieces_dict = []
for piece in pieces:
    if piece is not None:  # Add null check
        piece_dict = vars(piece).copy()
        piece_dict["movements"] = json.dumps([vars(m) for m in piece.movements])
        pieces_dict.append(piece_dict)

if pieces_dict: 
    df = pl.DataFrame(pieces_dict, strict=False, infer_schema_length=1000)
    current_datetime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = f"full_df_{current_datetime}.parquet"
    df.write_parquet(output_file)
    logger.info("Data saved to %s", output_file)
    os.system("pmset sleepnow")
else:
    logger.error("No valid pieces to save")

os.system("pmset sleepnow")
