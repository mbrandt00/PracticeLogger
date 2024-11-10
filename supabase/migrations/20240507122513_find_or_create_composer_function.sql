CREATE OR REPLACE FUNCTION find_or_create_composer(
    name TEXT
) RETURNS composers AS $$
DECLARE
    composer_record composers;
BEGIN
    -- Check if composer already exists
    SELECT * INTO composer_record FROM composers
    WHERE composers.name = find_or_create_composer.name;

    -- If composer does not exist, create a new one
    IF NOT FOUND THEN
        INSERT INTO composers (name)
        VALUES (find_or_create_composer.name)
        RETURNING * INTO composer_record;
    END IF;

    -- Return the composer record
    RETURN composer_record;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
