CREATE EXTENSION IF NOT EXISTS pg_trgm SCHEMA public;


-- more variables such as OPUS if exists could be boosted/ key signature etc
CREATE OR REPLACE FUNCTION check_piece_uniqueness()
RETURNS TRIGGER AS $$
DECLARE
    threshold FLOAT := 0.75; -- Adjust threshold as needed
BEGIN
    IF EXISTS (
        SELECT 1
        FROM pieces
        WHERE strict_word_similarity(workName, NEW.workName) > threshold
        AND userId = NEW.userId
    ) THEN
        RAISE EXCEPTION 'Piece with a similar workName already exists for this user';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_piece_uniqueness
BEFORE INSERT ON pieces
FOR EACH ROW
EXECUTE FUNCTION check_piece_uniqueness();

-- use as a when or as an inseret?
-- how to make queries efficient in Database.swift?