import json
from imslp_scraping import get_all_composer_pieces, get_composer_url
from pieces import create_piece
import datetime
import polars as pl
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)

# short_composers = ["Scriabin, Aleksandr"]

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
    logger.info(f"Starting import for {composer}")
    url = get_composer_url(composer)
    data = get_all_composer_pieces(url)
    for piece_url in data:
        if len(pieces) % 100 == 0:
            logger.info(f"Processed {len(pieces)} pieces")
        try:
            piece = create_piece(url=piece_url)
        except ValueError as e:
            logger.error(f"Error processing {piece_url}: {e}")
            continue
        pieces.append(piece)

pieces_dict = []
for piece in pieces:
    piece_dict = vars(piece).copy()
    piece_dict["movements"] = json.dumps([vars(m) for m in piece.movements])
    pieces_dict.append(piece_dict)

df = pl.DataFrame(pieces_dict, strict=False, infer_schema_length=1000)

current_datetime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
output_file = f"full_df_{current_datetime}.parquet"
df.write_parquet(output_file)
logger.info(f"Data saved to {output_file}")
