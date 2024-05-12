CREATE TYPE opus_type AS ENUM ('Op', 'K', 'BWV', 'D', 'L', 'WoO', 'B', 'Wq', 'CPEB', 'VB', 'DD', 'H', 'WD', 'WAB', 'T', 'FMW', 'EG', 'S', 'TH');

ALTER TABLE pieces
ADD COLUMN opus_type opus_type,
ADD COLUMN opus_number INTEGER;



CREATE OR REPLACE FUNCTION parse_opus_information()
RETURNS TRIGGER AS $$
DECLARE
    opus_types opus_type[];
    opus_type_value TEXT;
    opus_type_pattern TEXT;
BEGIN
    -- Get all possible opus types from the enum
    opus_types := ENUM_RANGE(NULL::opus_type);

    -- Iterate over each opus type
    FOREACH opus_type_value IN ARRAY opus_types
    LOOP
        -- Construct the regular expression pattern for the opus type
        opus_type_pattern := opus_type_value || '(\.|)(\s|\d)';

        -- Check if the workName matches the opus type pattern
        IF NEW.workName ~* opus_type_pattern THEN
            NEW.opus_type := opus_type_value;
            -- Extract the opus number
            NEW.opus_number := CAST(REGEXP_REPLACE(NEW.workName, '^.*?(' || opus_type_value || ')(\.|)(\s|)(\d+).*$','\4') AS INTEGER);
            RETURN NEW;
        END IF;
    END LOOP;

    -- If no match is found, set opus_type and opus_number to NULL
    NEW.opus_type := NULL;
    NEW.opus_number := NULL;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER parse_opus_information_trigger
BEFORE INSERT ON pieces
FOR EACH ROW
EXECUTE FUNCTION parse_opus_information();

-- CREATE OR REPLACE FUNCTION check_piece_uniqueness()
-- RETURNS TRIGGER AS $$
-- DECLARE
--     existing_record_count INTEGER;
-- BEGIN
--     SELECT COUNT(*)
--     INTO existing_record_count
--     FROM pieces
--     WHERE userId = NEW.userId
--     AND opus_type = NEW.opus_type
--     AND opus_number = NEW.opus_number;

--     IF existing_record_count > 1 THEN
--         RAISE EXCEPTION 'Piece with same catalogue information already exists.';
--     END IF;

--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- Create an AFTER INSERT trigger

ALTER TABLE pieces
ADD CONSTRAINT pieces_opus_unique UNIQUE (opus_type, opus_number, userId);