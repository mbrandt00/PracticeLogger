import pytest

from utils.pieces import create_piece, parse_metadata


def test_parse_metadata():
    sample_data = {
        "Incipit": "movements:1:2:3 (minuet):3 (trio):4:",
        "Movements/SectionsMov'ts/Sec's": "4 movements",
        "year_date_of_composition_y_d_of_comp": "1793-95",
        "Work Title": "Test name",
    }
    # print(type(sample_data))
    parsed = parse_metadata(sample_data)
    keys_to_check = ["composition_year"]

    assert parsed is not None
    assert all(key in parsed for key in keys_to_check)
    assert parsed["composition_year_string"] == "1793-95"
    assert parsed["composition_year"] == 1793


@pytest.mark.parametrize(
    "url, expected_data",
    [
        (
            "https://imslp.org/wiki/Cello_Sonata,_Op.65_(Chopin,_Fr%C3%A9d%C3%A9ric)",
            {
                "catalogue_number": 65,
                "title": "Cello Sonata",
                "catalogue_type": "op",
                "composition_year_string": "1846-1847 (summer)",
                "composition_year": 1846,
                "key_signature": "gminor",
                "movements_count": 4,
                "nickname": None,
                "instrumentation": ["cello", "piano"],
                "piece_style": "romantic",
                "sub_piece_type": "movements",
                "sub_piece_count": 4,
            },
        ),
        (
            "https://imslp.org/wiki/Piano_Sonata_No.23,_Op.57_(Beethoven,_Ludwig_van)",
            {
                "catalogue_number": 57,
                "title": "Piano Sonata No.23",
                "catalogue_type": "op",
                "composition_year_string": "1804–06",
                "composition_year": 1804,
                "key_signature": "fminor",
                "movements_count": 3,
                "nickname": "Appassionata",
                "instrumentation": ["piano"],
                "piece_style": "classical",
                "sub_piece_type": "movements",
                "sub_piece_count": 3,
            },
        ),
        (
            "https://imslp.org/wiki/French_Suite_No.4_in_E-flat_major%2C_BWV_815a_(Bach%2C_Johann_Sebastian)",
            {
                "catalogue_number": 815,
                "title": "French Suite No.4",
                "catalogue_type": "bwv",
                "composition_year_string": "1722-25 from theNotebooks for Anna Magdalena Bach(No.4)",
                "composition_year": 1722,
                "key_signature": "eflat",
                "movements_count": 6,
                "nickname": None,
                "instrumentation": ["keyboard"],
                "piece_style": "baroque",
                "sub_piece_type": "movements",
                "sub_piece_count": 7,
            },
        ),
        (
            "https://imslp.org/wiki/French_Suite_No.2_in_C_minor%2C_BWV_813_(Bach%2C_Johann_Sebastian)",
            {
                "catalogue_number": 813,
                "title": "French Suite No.2",
                "catalogue_type": "bwv",
                "composition_year_string": "1722 ca. from theNotebooks for Anna Magdalena Bach(Nos.2, 9, 31)",
                "composition_year": 1722,
                "key_signature": "cminor",
                "movements_count": 7,
                "nickname": None,
                "instrumentation": ["keyboard"],
                "piece_style": "baroque",
                "sub_piece_type": "movements",
                "sub_piece_count": 7,
            },
        ),
        (
            "https://imslp.org/wiki/French_Suite_No.1_(Godowsky%2C_Leopold)",
            {
                "catalogue_number": None,
                "title": "French Suite No.1",
                "catalogue_type": None,
                "composition_year_string": None,
                "composition_year": None,
                "key_signature": None,
                "movements_count": 3,
                "nickname": "Bergerettes",
                "instrumentation": ["Piano (solo)"],
                "piece_style": "romantic",
                "sub_piece_type": "pieces",
                "sub_piece_count": 3,
            },
        ),
    ],
)
def test_create_piece_from_tag(url, expected_data):
    data = create_piece(url=url)
    print("DATA", data)
    assert data is not None
    assert data.catalogue_number == expected_data["catalogue_number"]
    assert data.work_name == expected_data["title"]
    assert data.catalogue_type == expected_data["catalogue_type"]
    assert data.composition_year_string == expected_data["composition_year_string"]
    assert data.composition_year == expected_data["composition_year"]
    assert len(data.movements) == expected_data["movements_count"]
    assert data.key_signature == expected_data["key_signature"]
    assert data.nickname == expected_data["nickname"]
    assert data.instrumentation == expected_data["instrumentation"]
    assert data.piece_style == expected_data["piece_style"]
    assert data.sub_piece_type == expected_data["sub_piece_type"]
    assert data.sub_piece_count == expected_data["sub_piece_count"]


@pytest.mark.parametrize(
    "url, expected_data",
    [
        (
            "https://imslp.org/wiki/Violin_Sonata_No.1%2C_Op.12_No.1_(Beethoven%2C_Ludwig_van)",
            {
                "catalogue_number": 12,
                "title": "Violin Sonata No.1",
                "catalogue_type": "op",
                "composition_year_string": "1797-98",
                "composition_year": 1797,
                "key_signature": "d",
                "movements_count": 3,
                "nickname": None,
                "instrumentation": ["violin", "piano"],
                "piece_style": "classical",
                "catalogue_number_secondary": 1,
                "sub_piece_type": "movements",
            },
        ),
        (
            "https://imslp.org/wiki/Scherzo_No.1%2C_Op.20_(Chopin%2C_Fr%C3%A9d%C3%A9ric)",
            {
                "catalogue_number": 20,
                "title": "Scherzo No.1",
                "catalogue_type": "op",
                "composition_year_string": "1833",
                "composition_year": 1833,
                "key_signature": "bminor",
                "movements_count": 0,
                "nickname": None,
                "instrumentation": ["piano"],
                "piece_style": "romantic",
                "catalogue_number_secondary": None,
                "sub_piece_type": None,
            },
        ),
        (
            "https://imslp.org/index.php?title=Scherzo_No.3%2C_Op.39_%28Chopin%2C_Fr%C3%A9d%C3%A9ric%29",
            {
                "catalogue_number": 39,
                "title": "Scherzo No.3",
                "catalogue_type": "op",
                "composition_year_string": "1839",
                "composition_year": 1839,
                "key_signature": "csharpminor",
                "movements_count": 0,
                "nickname": None,
                "instrumentation": ["piano"],
                "piece_style": "romantic",
                "catalogue_number_secondary": None,
                "sub_piece_type": None,
            },
        ),
        (
            "https://imslp.org/wiki/8_Etudes,_Op.42_(Scriabin,_Aleksandr)",
            {
                "catalogue_number": 42,
                "title": "Eight Etudes",
                "catalogue_type": "op",
                "composition_year_string": "1903",
                "composition_year": 1903,
                "key_signature": None,
                "movements_count": 8,
                "nickname": "Восемь этюдов",  #
                "instrumentation": ["piano"],
                "piece_style": "romantic",
                "catalogue_number_secondary": None,
                "sub_piece_type": "etudes",
            },
        ),
        (
            "https://imslp.org/wiki/Rhapsody_on_a_Theme_of_Paganini%2C_Op.43_(Rachmaninoff%2C_Sergei)",
            {
                "catalogue_number": 43,
                "title": "Rhapsody on a Theme of Paganini",
                "catalogue_type": "op",
                "composition_year_string": "1934",
                "composition_year": 1934,
                "key_signature": 'aminor',
                "movements_count": 25,
                "nickname": "Рапсодия на тему Паганини (Rapsodiya na temu Paganini)",  #
                "instrumentation": ["piano", "orchestra"],
                "piece_style": "romantic",
                "catalogue_number_secondary": None,
                "sub_piece_type": "variations",
            },
        ),
        (
            "https://imslp.org/wiki/Pr%C3%A9ludes,_Livre_1_(Debussy,_Claude)",
            {
                "catalogue_number": 125,
                "title": "Préludes, Premier Livre",
                "catalogue_type": "cd",
                "composition_year_string": "1909-10",
                "composition_year": 1909,
                "key_signature":None,
                "movements_count": 12,
                "nickname":None,
                "instrumentation": ["piano"],
                "piece_style": "romantic",
                "catalogue_number_secondary": None,
                "sub_piece_type": "preludes",
            },
        ),
        (
            "https://imslp.org/wiki/Violin_Sonata_in_F_major,_MWV_Q_7_(Mendelssohn,_Felix) ",
            {
                "catalogue_number": 7,
                "title": "Violin Sonata",
                "catalogue_type": "mwvq",
                "composition_year_string": "1820",
                "composition_year": 1820,
                "key_signature":'f',
                "movements_count": 3,
                "nickname":None,  
                "instrumentation": ["violin", "piano"],
                "piece_style": "romantic",
                "catalogue_number_secondary": None,
                "sub_piece_type": "movements",
            },
        ),
        (
            "https://imslp.org/wiki/Le_temple_universel,_H_137_(Berlioz,_Hector)",
            {
                "catalogue_number": 137,
                "title": "Le temple universel",
                "catalogue_type": "h",
                "composition_year_string": "1861, rev. 1868",
                "composition_year": 1861,
                "key_signature":None,
                "movements_count": 0,
                "nickname":None,  
                "instrumentation":  ['TTBB—TTBB', 'organTTBB a capella'],
                "piece_style": "romantic",
                "catalogue_number_secondary": None,
                "sub_piece_type": None
            },
        ),
    ],
)
def test_create_piece_from_url(url, expected_data):
    data = create_piece(url=url)
    print(data)
    assert data is not None
    assert data.catalogue_number == expected_data["catalogue_number"]
    assert data.work_name == expected_data["title"]
    assert data.catalogue_type == expected_data["catalogue_type"]
    assert data.composition_year_string == expected_data["composition_year_string"]
    assert data.composition_year == expected_data["composition_year"]
    assert len(data.movements) == expected_data["movements_count"]
    assert data.key_signature == expected_data["key_signature"]
    assert data.nickname == expected_data["nickname"]
    assert data.instrumentation == expected_data["instrumentation"]
    assert data.piece_style == expected_data["piece_style"]
    assert (
        data.catalogue_number_secondary == expected_data["catalogue_number_secondary"]
    )
    assert data.sub_piece_type == expected_data["sub_piece_type"]


