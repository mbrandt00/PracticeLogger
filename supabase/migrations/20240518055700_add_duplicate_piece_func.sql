CREATE OR REPLACE FUNCTION find_duplicate_piece(
    catalogue_number INT,
    catalogue_type catalogue_type,
    user_id UUID,
    composer_name TEXT
) RETURNS pieces AS $$
DECLARE
    matching_piece pieces;
    found_composer_id INT;
BEGIN
    -- Find or create the composer record
    SELECT id INTO found_composer_id FROM find_or_create_composer(composer_name);

    -- Find the matching piece
    SELECT *
    INTO matching_piece
    FROM pieces
    WHERE pieces.catalogue_number = $1
        AND pieces.catalogue_type = $2
        AND pieces.user_id = $3
        AND pieces.composer_id = found_composer_id
    LIMIT 1;

    RETURN matching_piece;
END;
$$ LANGUAGE plpgsql;