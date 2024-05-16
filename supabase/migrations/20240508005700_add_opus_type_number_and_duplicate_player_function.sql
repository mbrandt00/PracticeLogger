CREATE TYPE opus_type AS ENUM ('Op', 'K', 'BWV', 'D', 'L', 'WoO', 'B', 'Wq', 'CPEB', 'VB', 'DD', 'H', 'WD', 'WAB', 'T', 'FMW', 'EG', 'S', 'TH');
CREATE TYPE piece_format AS ENUM ('Bagatelle', 'Ballade', 'Canon', 'Caprice', 'Chorale', 'Concerto', 'Dance', 'Etude', 'Fantasy', 'Fugue', 'Gavotte', 'Gigue', 'Impromptu', 'Intermezzo', 'Lied', 'March', 'Mazurka', 'Mass', 'Minuet', 'Nocturne', 'Overture', 'Opera', 'Oratorio', 'Pastiche', 'Prelude', 'Polonaise', 'Rhapsody', 'Requiem', 'Rondo', 'Sarabande', 'Scherzo', 'Seranade', 'Sonata', 'String Quartet', 'Suite', 'Symphony', 'Tarantella', 'Toccata', 'Variations', 'Waltz' );

CREATE TYPE key_signature_type AS ENUM (
    'C', 'C#', 'Cb',
    'D', 'D#', 'Db',
    'E', 'E#', 'Eb',
    'F', 'F#', 'Fb',
    'G', 'G#', 'Gb',
    'A', 'A#', 'Ab',
    'B', 'B#', 'Bb'
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
    found_key key_signature_type;
BEGIN
    key_info := NULL;

    -- Find the key signature
    found_key := (
        SELECT CASE
            WHEN lower(work_name) LIKE '%c#%' OR lower(work_name) LIKE '%c sharp%' THEN 'C#'
            WHEN lower(work_name) LIKE '%c-flat%' OR lower(work_name) LIKE '%c flat%' THEN 'Cb'
            WHEN lower(work_name) LIKE '%d#%' OR lower(work_name) LIKE '%d sharp%' THEN 'D#'
            WHEN lower(work_name) LIKE '%d-flat%' OR lower(work_name) LIKE '%d flat%' THEN 'Db'
            WHEN lower(work_name) LIKE '%e#%' OR lower(work_name) LIKE '%e sharp%' THEN 'E#'
            WHEN lower(work_name) LIKE '%e-flat%' OR lower(work_name) LIKE '%e flat%' THEN 'Eb'
            WHEN lower(work_name) LIKE '%f#%' OR lower(work_name) LIKE '%f sharp%' THEN 'F#'
            WHEN lower(work_name) LIKE '%f-flat%' OR lower(work_name) LIKE '%f flat%' THEN 'Fb'
            WHEN lower(work_name) LIKE '%g#%' OR lower(work_name) LIKE '%g sharp%' THEN 'G#'
            WHEN lower(work_name) LIKE '%g-flat%' OR lower(work_name) LIKE '%g flat%' THEN 'Gb'
            WHEN lower(work_name) LIKE '%a#%' OR lower(work_name) LIKE '%a sharp%' THEN 'A#'
            WHEN lower(work_name) LIKE '%a-flat%' OR lower(work_name) LIKE '%a flat%' THEN 'Ab'
            WHEN lower(work_name) LIKE '%b#%' OR lower(work_name) LIKE '%b sharp%' THEN 'B#'
            WHEN lower(work_name) LIKE '%b-flat%' OR lower(work_name) LIKE '%b flat%' THEN 'Bb'
            ELSE NULL
        END
    );

    -- Set the found key signature
    key_info.key := found_key;

    -- Determine the tonality
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
    opus_number_text TEXT;
    opus_number_int INT;
BEGIN
    -- Initialize opus_info to NULL
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
            -- Extract the opus number as text
            opus_number_text := REGEXP_REPLACE(work_name, '^.*?(' || opus_type_value || ')(\.|)(\s|)(\d+).*$','\4');

            -- Attempt to convert opus number text to integer
            BEGIN
                opus_number_int := CAST(opus_number_text AS INTEGER);
            EXCEPTION WHEN OTHERS THEN
                -- Set opus number to NULL if conversion fails
                opus_number_int := NULL;
            END;

            -- If opus number is NULL, set opus type to NULL as well
            IF opus_number_int IS NULL THEN
                opus_type_value := NULL;
            END IF;

            -- Assign opus type and opus number to opus_info
            opus_info := ROW(opus_type_value, opus_number_int);
            EXIT; -- Exit loop after finding a match
        END IF;
    END LOOP;

    -- Return opus_info or NULL if not found
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

CREATE TYPE PieceMetadata AS (
    opus_type opus_type,
    opus_number INT,
    piece_format piece_format,
    key_signature_type key_signature_type,
    key_signature_tonality key_signature_tonality

);

CREATE OR REPLACE FUNCTION parse_piece_metadata(work_name TEXT)
RETURNS PieceMetadata AS $$
DECLARE
    opus_info OpusInformation;
    piece_format_value piece_format;
    key_signature_value KeySignature;
    metadata PieceMetadata;
BEGIN
    -- Call parse_opus_information to get opus information
    opus_info := parse_opus_information(work_name);

    -- Call parse_piece_format to get piece format
    piece_format_value := parse_piece_format(work_name);

    -- Call parse_piece_key_signature to get key signature
    key_signature_value := parse_piece_key_signature(work_name);

    -- Assign values to metadata
    metadata.opus_type := opus_info.opus_type;
    metadata.opus_number := opus_info.opus_number;
    metadata.piece_format := piece_format_value;
    metadata.key_signature_type := key_signature_value.key;
    metadata.key_signature_tonality := key_signature_value.tonality;

    -- Return combined metadata
    RETURN metadata;
END
$$ LANGUAGE plpgsql;