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