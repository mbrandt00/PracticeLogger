CREATE TYPE catalogue_type AS ENUM ('op', 'k', 'bwv', 'd', 'l', 'woo', 'b', 'wq', 'cpeb', 'vb', 'dd', 'h', 'wd', 'wab', 't', 'fmw', 'eg', 's', 'th', 'twv', 'rv');

CREATE TYPE opus_information AS (
    catalogue_type catalogue_type,
    catalogue_number INT
);

CREATE OR REPLACE FUNCTION parse_opus_information(work_name TEXT)
RETURNS opus_information AS $$
DECLARE
    catalogue_types catalogue_type[];
    catalogue_type_value TEXT;
    catalogue_type_pattern TEXT;
    opus_info opus_information;
    catalogue_number_text TEXT;
    catalogue_number_int INT;
BEGIN
    -- Initialize opus_info to NULL
    opus_info := NULL;

    -- Get all possible opus types from the enum
    catalogue_types := ENUM_RANGE(NULL::catalogue_type);

    -- Iterate over each opus type
    FOREACH catalogue_type_value IN ARRAY catalogue_types
    LOOP
        -- Construct the regular expression pattern for the opus type
        catalogue_type_pattern := catalogue_type_value || '(\.|)(\s|\d)';

        -- Check if the workName matches the opus type pattern
        IF work_name ~* catalogue_type_pattern THEN
            -- Extract the opus number as text
            catalogue_number_text := REGEXP_REPLACE(work_name, '^.*?(' || catalogue_type_value || ')(\.|)(\s|)(\d+).*$','\4');

            -- Attempt to convert opus number text to integer
            BEGIN
                catalogue_number_int := CAST(catalogue_number_text AS INTEGER);
            EXCEPTION WHEN OTHERS THEN
                -- Set opus number to NULL if conversion fails
                catalogue_number_int := NULL;
            END;

            IF catalogue_number_int IS NULL THEN
                catalogue_type_value := NULL;
            END IF;

            opus_info := ROW(catalogue_type_value, catalogue_number_int);
            EXIT; -- Exit loop after finding a match
        END IF;
    END LOOP;

    -- Return opus_info or NULL if not found
    RETURN opus_info;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE pieces
ADD COLUMN catalogue_type catalogue_type,
ADD COLUMN catalogue_number INT;
