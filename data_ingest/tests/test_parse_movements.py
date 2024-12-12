import pytest

from utils.movements import parse_key_signature, parse_movements


# Key signature parsing tests
@pytest.mark.parametrize(
    "test_input,expected",
    [
        ("C ♯", "csharp"),
        ("D ♭", "dflat"),
        ("E♯", "esharp"),
        ("C flat", "cflat"),
        ("E-flat major", "eflat"),
        ("Allegretto non tanto in F♯ minor", "fsharpminor"),
        ("Doloroso in D♯ minor", "dsharpminor"),
        ("Presto  = 192-200 (D♭ major)", "dflat"),
        ("F♯ major", "fsharp"),
        ("Allegro (B♭ major.  = 138)", "bflat"),  # hammerklavier
        (
            "Introduzione. Largo ( = 76) - Fuga: Allegro risoluto (B♭ major.  = 144))",
            "bflat",
        ),  # hammerklavier
        (
            "D<span class=\"music-symbol\" style='font-family: Arial Unicode MS, Lucida Sans Unicode; font-size:110%'>♭</span> major)",
            "dflat",
        ),
    ],
)
def test_parse_key_signature(test_input, expected):
    assert parse_key_signature(test_input) == expected


# Movement parsing tests
def test_parse_piece_movements():
    result = parse_movements(
        url="https://imslp.org/wiki/Cello_Sonata,_Op.65_(Chopin,_Fr%C3%A9d%C3%A9ric)"
    )
    assert result[0].key_signature == "gminor"
    assert result[1].key_signature == "dminor"
    # number
    assert result[0].number == 1
    assert result[1].number == 2
    # clean name without number
    assert result[0].title == "Allegro moderato"
    assert result[1].title == "Scherzo"


def test_parse_piece_sections():
    result = parse_movements(
        url="https://imslp.org/wiki/13_Preludes,_Op.32_(Rachmaninoff,_Sergei)"
    )
    assert isinstance(result, list)
    # key signature
    assert result[0].key_signature == "c"
    assert result[1].key_signature == "bflatminor"
    # number
    assert result[0].number == 1
    assert result[1].number == 2
    # clean name without number
    assert result[0].title == "Allegro vivace"
    assert result[1].title == "Allegretto"
    # url
    print(result)
    assert (
        result[0].download_url == "https://imslp.org/wiki/Special:ImagefromIndex/309270"
    )
    assert (
        result[1].download_url == "https://imslp.org/wiki/Special:ImagefromIndex/309271"
    )


# Nickname and movement count tests
def test_create_piece_with_sub_piece_and_nickname():
    data = parse_movements(
        url="https://imslp.org/wiki/%C3%89tudes,_Op.25_(Chopin,_Fr%C3%A9d%C3%A9ric)"
    )
    print(data)
    assert len(data) == 12
    assert data[0].nickname == "Aeolian Harp"
    assert data[1].nickname == "The Bees"
    assert data[2].nickname == "The Horseman"
    assert data[3].nickname == "Paganini"
    assert data[4].nickname == "Wrong Note"
    assert data[5].nickname == "Thirds"
    assert data[6].nickname == "Cello"
    assert data[0].key_signature == "aflat"
    assert data[1].key_signature == "fminor"
    assert data[2].key_signature == "f"
    assert data[3].key_signature == "aminor"
    assert data[4].key_signature == "eminor"
    assert data[5].key_signature == "gsharpminor"
    assert data[6].key_signature == "csharpminor"


def test_parse_nickname():
    data = parse_movements(
        url="https://imslp.org/wiki/4_Pieces%2C_Op.56_(Scriabin%2C_Aleksandr)"
    )
    assert data[0].title == "Prelude"


def test_movement():
    data = parse_movements(
        url="https://imslp.org/wiki/10_Pieces_for_Piano,_Op.12_(Prokofiev,_Sergey)"
    )
    print(data)
    assert len(data) == 10
    assert data[0].key_signature is None


def test_div_movement():
    data = parse_movements(
        url="https://imslp.org/wiki/Suite_bergamasque_(Debussy,_Claude)"
    )
    assert data[0].title == "Prélude"
    assert data[1].title == "Menuet"
    assert data[2].title == "Clair de lune"
    assert data[3].title == "Passepied"


def test_remove_tempo_symbol_from_name():
    data = parse_movements(
        url="https://imslp.org/wiki/Piano_Sonata_No.29,_Op.106_(Beethoven,_Ludwig_van"
    )
    print(data)
    assert data[0].title == "Allegro"
    assert data[1].title == "Scherzo. Assai vivace"
    assert data[2].title == "Adagio sostenuto"
    assert data[3].title == "Introduzione. Largo - Fuga: Allegro risoluto"


def test_remove_links_from_movement_name():
    data = parse_movements(
        url="https://imslp.org/wiki/Preludes,_Op.28_(Chopin,_Fr%C3%A9d%C3%A9ric)"
    )
    assert data[0].title == "Agitato"
    assert data[0].key_signature == "c"
    assert data[1].title == "Lento"
    assert data[1].key_signature == "aminor"
