CREATE TYPE piece_format AS ENUM ('Bagatelle', 'Ballade', 'Canon', 'Caprice', 'Chorale', 'Concerto', 'Dance', 'Etude', 'Fantasy', 'Fugue', 'Gavotte', 'Gigue', 'Impromptu', 'Intermezzo', 'Lied', 'March', 'Mazurka', 'Mass', 'Minuet', 'Nocturne', 'Overture', 'Opera', 'Oratorio', 'Pastiche', 'Prelude', 'Polonaise', 'Rhapsody', 'Requiem', 'Rondo', 'Sarabande', 'Scherzo', 'Seranade', 'Sonata', 'String Quartet', 'Suite', 'Symphony', 'Tarantella', 'Toccata', 'Variations', 'Waltz' );

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

ALTER TABLE pieces
ADD COLUMN format piece_format;