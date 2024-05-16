CREATE TYPE opus_type AS ENUM ('Op', 'K', 'BWV', 'D', 'L', 'WoO', 'B', 'Wq', 'CPEB', 'VB', 'DD', 'H', 'WD', 'WAB', 'T', 'FMW', 'EG', 'S', 'TH');
CREATE TYPE piece_format AS ENUM ('Bagatelle', 'Ballade', 'Canon', 'Caprice', 'Chorale', 'Concerto', 'Dance', 'Etude', 'Fantasy', 'Fugue', 'Gavotte', 'Gigue', 'Impromptu', 'Intermezzo', 'Lied', 'March', 'Mazurka', 'Mass', 'Minuet', 'Nocturne', 'Overture', 'Opera', 'Oratorio', 'Pastiche', 'Prelude', 'Polonaise', 'Rhapsody', 'Requiem', 'Rondo', 'Sarabande', 'Scherzo', 'Seranade', 'Sonata', 'String Quartet', 'Suite', 'Symphony', 'Tarantella', 'Toccata', 'Variations', 'Waltz' );

CREATE TYPE key_signature_type AS ENUM (
    'C', 'G', 'D', 'A', 'E', 'B', 'F#', 'C#', 'F', 'Bb', 'Eb', 'Ab', 'Db', 'Gb', 'Cb'
);
CREATE TYPE key_signature_tonality AS ENUM (
    'Major', 'Minor'
);
CREATE TYPE KeySignature AS (
    key key_signature_type,
    tonality key_signature_tonality
);
CREATE OR REPLACE FUNCTION parse_piece_key_signature(work_name TEXT)
RETURNS KeySignature AS $$
DECLARE
    key_info KeySignature;
    key_signature_pattern TEXT;
BEGIN
    key_info := NULL;
    key_signature_pattern := '([A-G])(?:[-\s]*)(?:(?:flat)|(?:sharp)|(?:#)|(?:b))?';

    SELECT
        substring(work_name from key_signature_pattern)
    INTO
        key_info.key;

    IF lower(work_name) LIKE '%minor%' THEN
        key_info.tonality := 'Minor';
    ELSE
        key_info.tonality := 'Major';
    END IF;

    RETURN key_info;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE pieces
ADD COLUMN opus_type opus_type,
ADD COLUMN piece_format piece_format,
ADD COLUMN opus_number INTEGER,
ADD COLUMN format piece_format,
ADD COLUMN key_signature_type key_signature_type,
ADD COLUMN key_signature_tonality key_signature_tonality;

CREATE TYPE OpusInformation AS (
    opus_type opus_type,
    opus_number INT
);

CREATE OR REPLACE FUNCTION parse_opus_information(work_name TEXT)
RETURNS OpusInformation AS $$
DECLARE
    opus_types opus_type[];
    opus_type_value TEXT;
    opus_type_pattern TEXT;
    opus_info OpusInformation;
BEGIN
    -- Initialize opus_info
    opus_info := NULL;

    -- Get all possible opus types from the enum
    opus_types := ENUM_RANGE(NULL::opus_type);

    -- Iterate over each opus type
    FOREACH opus_type_value IN ARRAY opus_types
    LOOP
        -- Construct the regular expression pattern for the opus type
        opus_type_pattern := opus_type_value || '(\.|)(\s|\d)';

        -- Check if the workName matches the opus type pattern
        IF work_name ~* opus_type_pattern THEN
            -- Assign opus type and opus number to opus_info
            opus_info := ROW(opus_type_value, CAST(REGEXP_REPLACE(work_name, '^.*?(' || opus_type_value || ')(\.|)(\s|)(\d+).*$','\4') AS INTEGER));
            EXIT; -- Exit loop after finding a match
        END IF;
    END LOOP;

    -- Return opus_info
    RETURN opus_info;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION parse_piece_format(work_name TEXT)
RETURNS piece_format AS $$
DECLARE
    piece_format_value piece_format;
    piece_formats piece_format[];
BEGIN
    piece_formats := ENUM_RANGE(NULL::piece_format);
    FOREACH piece_format_value IN ARRAY piece_formats
    LOOP
        IF work_name ILIKE '%' || piece_format_value || '%' THEN
            RETURN piece_format_value;
        END IF;
    END LOOP;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--
CREATE OR REPLACE FUNCTION find_duplicate_piece(
    opus_number INT,
    opus_type opus_type,
    user_id UUID,
    composer_name TEXT
) RETURNS pieces AS $$
DECLARE
    matching_piece pieces;
    composer_id INT;
BEGIN
    -- Find or create the composer record
    SELECT id INTO composer_id FROM find_or_create_composer(composer_name);

    -- Find the matching piece
    SELECT *
    INTO matching_piece
    FROM pieces
    WHERE pieces.opus_number = $1
        AND pieces.opus_type = $2
        AND pieces.userId = $3
        AND pieces.composerId = composer_id
    LIMIT 1;

    RETURN matching_piece;
END;
$$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION parse_piece_metadata(work_name TEXT)
-- RETURNS PieceMetadata AS $$
-- DECLARE
--     opus_info OpusInformation;
--     piece_format_value piece_format;
-- BEGIN
--     -- Call parse_opus_information to get opus information
--     opus_info := parse_opus_information(work_name);

--     -- Call parse_piece_format to get piece format
--     piece_format_value := parse_piece_format(work_name);

--     -- Return combined metadata
--     RETURN (opus_info.opus_type, opus_info.opus_number, piece_format_value);
-- END
-- $$ LANGUAGE plpgsql;
-- select * from parse_piece_metadata('Concerto for Piano and Orchestra No. 2 in C Minor, Op. 18');
-- $$ LANGUAGE plpgsql;