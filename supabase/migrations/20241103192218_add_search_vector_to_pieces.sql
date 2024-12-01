CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
ALTER TABLE pieces ADD COLUMN IF NOT EXISTS searchable_text TEXT;

-- Helper function to generate searchable text - simplified but maintains all search fields
CREATE OR REPLACE FUNCTION get_piece_searchable_text(piece_id BIGINT) RETURNS TEXT AS $$
    SELECT 
        CONCAT_WS(' ',
            unaccent(p.work_name),
            unaccent(p.nickname),
            unaccent(c.name),
            (SELECT string_agg(unaccent(name) || ' ' || COALESCE(unaccent(nickname), ''), ' ')
             FROM movements 
             WHERE piece_id = $1)
        )
    FROM pieces p
    LEFT JOIN composers c ON c.id = p.composer_id
    WHERE p.id = piece_id;
$$ LANGUAGE sql SECURITY DEFINER;

-- Create index for faster searching
CREATE INDEX IF NOT EXISTS idx_pieces_searchable_text_trgm 
ON pieces USING gin (searchable_text gin_trgm_ops);

-- Main search function
CREATE OR REPLACE FUNCTION search_piece_with_associations(query text) 
RETURNS SETOF pieces AS $$
    WITH terms AS (
        SELECT unnest(string_to_array(lower(unaccent(query)), ' ')) as term
    )
    SELECT p.*
    FROM pieces p
    WHERE searchable_text IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM terms
        WHERE lower(p.searchable_text) NOT LIKE '%' || term || '%'
    )
    ORDER BY similarity(p.searchable_text, unaccent(query)) DESC;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Triggers to maintain searchable text
CREATE OR REPLACE FUNCTION update_piece_searchable_text() RETURNS trigger AS $$
BEGIN
    NEW.searchable_text := get_piece_searchable_text(NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER piece_searchable_text_update
    BEFORE INSERT OR UPDATE ON pieces
    FOR EACH ROW
    EXECUTE FUNCTION update_piece_searchable_text();

CREATE OR REPLACE FUNCTION update_movement_piece_searchable_text() RETURNS trigger AS $$
BEGIN
    UPDATE pieces
    SET searchable_text = get_piece_searchable_text(
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.piece_id 
            ELSE NEW.piece_id 
        END
    )
    WHERE id = CASE 
        WHEN TG_OP = 'DELETE' THEN OLD.piece_id 
        ELSE NEW.piece_id 
    END;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER movement_update_piece_searchable_text
    AFTER INSERT OR UPDATE OR DELETE ON movements
    FOR EACH ROW
    EXECUTE FUNCTION update_movement_piece_searchable_text();

