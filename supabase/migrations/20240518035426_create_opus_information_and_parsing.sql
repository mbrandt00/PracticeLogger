CREATE TYPE opus_type AS ENUM ('Op', 'K', 'BWV', 'D', 'L', 'WoO', 'B', 'Wq', 'CPEB', 'VB', 'DD', 'H', 'WD', 'WAB', 'T', 'FMW', 'EG', 'S', 'TH');

CREATE TYPE opus_information AS (
    opus_type opus_type,
    opus_number INT
);

CREATE OR REPLACE FUNCTION parse_opus_information(work_name TEXT)
RETURNS opus_information AS $$
DECLARE
    opus_types opus_type[];
    opus_type_value TEXT;
    opus_type_pattern TEXT;
    opus_info opus_information;
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

            IF opus_number_int IS NULL THEN
                opus_type_value := NULL;
            END IF;

            opus_info := ROW(opus_type_value, opus_number_int);
            EXIT; -- Exit loop after finding a match
        END IF;
    END LOOP;

    -- Return opus_info or NULL if not found
    RETURN opus_info;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE pieces
ADD COLUMN opus_type opus_type,
ADD COLUMN opus_number INT;