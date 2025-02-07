import polars as pl
from urllib.parse import  unquote
import unicodedata
import os
import logging
import json
from pathlib import Path


logger = logging.getLogger(__name__)
current_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def normalize_composer_name(composer_name: str) -> str:
    """
    Normalize composer name by removing accents, special characters, 
    and converting to a consistent format.
    """
    # Remove accents
    normalized = unicodedata.normalize('NFKD', composer_name).encode('ASCII', 'ignore').decode('utf-8')
    
    # Convert to lowercase
    normalized = normalized.lower()
    
    # Remove special characters except comma
    normalized = ''.join(c for c in normalized if c.isalnum() or c == ',')
    
    # Handle both name formats
    if ',' in normalized:
        # Already in "Last, First" format
        last, first = normalized.split(',', 1)
    else:
        # Convert from "First Last" to "Last, First" format
        parts = normalized.split()
        if len(parts) >= 2:
            last = parts[-1]
            first = ' '.join(parts[:-1])
        else:
            last = normalized
            first = ''
    
    # Return cleaned "last_first" format
    return f"{last.strip()}_{first.strip()}"

def extract_piece_name(url: str) -> str:
    """
    Extract just the piece name from an IMSLP URL, ignoring composer and encoding differences.
    Examples: 
    "https://imslp.org/wiki/Waltzes%2C_Op.64_(Chopin%2C_Fr%C3%A9d%C3%A9ric)" -> "Waltzes,Op.64"
    "https://imslp.org/wiki/Piano_Sonata_No.2,Op.35_(Bach,_J.S.)" -> "PianoSonataNo.2,Op.35"
    """
    try:
        # First decode any URL encoding
        decoded = unquote(url)
        
        # Extract everything between 'wiki/' and first '('
        wiki_part = decoded.split('wiki/')[-1]
        piece = wiki_part.split('(')[0]
        
        # Clean up any remaining spaces or underscores
        piece = piece.replace('_', '').replace(' ', '')
        
        return piece.strip('_').strip()
    except Exception as e:
        logger.error(f"Error extracting piece name from {url}: {e}")
        return url


def urls_match(url1: str, url2: str) -> bool:
    """Compare two IMSLP URLs by their piece names only"""
    return extract_piece_name(url1) == extract_piece_name(url2)


def load_collections_mapping(composer_name: str) -> dict:
    """Load collections mapping for a given composer"""
    # Normalize the composer name
    clean_name = normalize_composer_name(composer_name)
    
    # Get path by going up one directory from current file location
    filename = os.path.join(current_dir, "collections_mapping", f"{clean_name}.json")
    
    try:
        with open(filename, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return {}
    
if __name__ == '__main__':
    # Set up logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )

    # Load collections data
    data = load_collections_mapping('Chopin, Frédéric')
    
    # Configure Polars display
    pl.Config.set_tbl_width_chars(None)
    pl.Config.set_tbl_rows(-1)
    pl.Config.set_tbl_width_chars(1000)

    # Load DataFrame
    df_location = os.path.join(current_dir, "full_df_20250111_144136.parquet")
    df = pl.read_parquet(df_location)

    # Track matches and non-matches
    matched_urls = set()
    match_count = 0
    
    # Iterate through DataFrame URLs
    for url in df['imslp_url']:
        found_match = False
        for collection_name, collection_data in data.items():
            for piece_url in collection_data['pieces']:
                if urls_match(url, piece_url):
                    match_count += 1
                    matched_urls.add(url)
                    logger.info(f"Match found for {url}")
                    logger.info(f"Collection: {collection_name}")
                    logger.info(f"Matched with: {piece_url}")
                    logger.info("-" * 80)
                    found_match = True
                    break
            if found_match:
                break
        
        if not found_match:
            logger.warning(f"No match found for: {url}")
            logger.warning(f"Extracted piece name: {extract_piece_name(url)}")
            logger.warning("-" * 80)

    # Print summary
    total_urls = len(df['imslp_url'])
    logger.info(f"Summary:")
    logger.info(f"Total URLs processed: {total_urls}")
    logger.info(f"Total matches found: {match_count}")
    logger.info(f"Match rate: {(match_count/total_urls)*100:.2f}%")