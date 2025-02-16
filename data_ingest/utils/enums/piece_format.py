import unicodedata
from enum import Enum
from typing import Optional


class PieceFormat(Enum):
    BAGATELLE = "bagatelle"
    BALLADE = "ballade"
    CANON = "canon"
    CAPRICE = "caprice"
    CHORALE = "chorale"
    CONCERTO = "concerto"
    DANCE = "dance"
    ETUDE = "etude"
    FANTASY = "fantasy"
    FUGUE = "fugue"
    GAVOTTE = "gavotte"
    GIGUE = "gigue"
    IMPROMPTU = "impromptu"
    INTERMEZZO = "intermezzo"
    LIED = "lied"
    MARCH = "march"
    MAZURKA = "mazurka"
    MASS = "mass"
    MINUET = "minuet"
    NOCTURNE = "nocturne"
    OVERTURE = "overture"
    OPERA = "opera"
    ORATORIO = "oratorio"
    PASTICHE = "pastiche"
    PRELUDE = "prelude"
    POLONAISE = "polonaise"
    RHAPSODY = "rhapsody"
    REQUIEM = "requiem"
    RONDO = "rondo"
    SARABANDE = "sarabande"
    SCHERZO = "scherzo"
    SERANADE = "seranade"
    SONATA = "sonata"
    STRING_QUARTET = "string_quartet"
    SUITE = "suite"
    SYMPHONY = "symphony"
    TARANTELLA = "tarantella"
    TOCCATA = "toccata"
    VARIATIONS = "variations"
    WALTZ = "waltz"


def strip_accents(text: str) -> str:
    """
    Strip accents from input string.
    """
    return ''.join(c for c in unicodedata.normalize('NFKD', text)
                  if unicodedata.category(c) != 'Mn')

def parse_piece_format(work_title: str) -> Optional[PieceFormat]:
    """
    Parse the piece format from the work title.
    Args:
        work_title: The title of the work
    Returns:
        PieceFormat or None if no format could be determined
    """
    # Normalize the title: remove accents and convert to lowercase
    title_normalized = strip_accents(work_title.lower())
    
    # Create a mapping of keywords to piece formats
    format_keywords = {
        'bagatelle': PieceFormat.BAGATELLE,
        'ballade': PieceFormat.BALLADE,
        'canon': PieceFormat.CANON,
        'caprice': PieceFormat.CAPRICE,
        'chorale': PieceFormat.CHORALE,
        'concerto': PieceFormat.CONCERTO,
        'dance': PieceFormat.DANCE,
        'etude': PieceFormat.ETUDE,
        'etudes': PieceFormat.ETUDE,
        'fantasy': PieceFormat.FANTASY,
        'fantasia': PieceFormat.FANTASY,
        'fugue': PieceFormat.FUGUE,
        'gavotte': PieceFormat.GAVOTTE,
        'gigue': PieceFormat.GIGUE,
        'impromptu': PieceFormat.IMPROMPTU,
        'intermezzo': PieceFormat.INTERMEZZO,
        'lied': PieceFormat.LIED,
        'march': PieceFormat.MARCH,
        'mazurka': PieceFormat.MAZURKA,
        'mass': PieceFormat.MASS,
        'minuet': PieceFormat.MINUET,
        'nocturne': PieceFormat.NOCTURNE,
        'overture': PieceFormat.OVERTURE,
        'opera': PieceFormat.OPERA,
        'oratorio': PieceFormat.ORATORIO,
        'pastiche': PieceFormat.PASTICHE,
        'prelude': PieceFormat.PRELUDE,
        'preludes': PieceFormat.PRELUDE,
        'polonaise': PieceFormat.POLONAISE,
        'rhapsody': PieceFormat.RHAPSODY,
        'requiem': PieceFormat.REQUIEM,
        'rondo': PieceFormat.RONDO,
        'sarabande': PieceFormat.SARABANDE,
        'scherzo': PieceFormat.SCHERZO,
        'serenade': PieceFormat.SERANADE,
        'sonata': PieceFormat.SONATA,
        'string quartet': PieceFormat.STRING_QUARTET,
        'suite': PieceFormat.SUITE,
        'symphony': PieceFormat.SYMPHONY,
        'tarantella': PieceFormat.TARANTELLA,
        'toccata': PieceFormat.TOCCATA,
        'variation': PieceFormat.VARIATIONS,
        'variations': PieceFormat.VARIATIONS,
        'waltz': PieceFormat.WALTZ
    }
    
    # Check for each format keyword in the normalized title
    for keyword, format_type in format_keywords.items():
        if keyword in title_normalized:
            return format_type
            
    return None
