CREATE TYPE opus_type AS ENUM ('Op', 'K', 'BWV', 'D', 'L', 'WoO', 'B', 'Wq', 'CPEB', 'VB', 'DD', 'H', 'WD', 'WAB', 'T', 'FMW', 'EG', 'S', 'TH');

ALTER TABLE pieces
ADD COLUMN opus_type opus_type,
ADD COLUMN opus_number INTEGER;

CREATE TYPE OpusInformation AS (
    opus_type TEXT,
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