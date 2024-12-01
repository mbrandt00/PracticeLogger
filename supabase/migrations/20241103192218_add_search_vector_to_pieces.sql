CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
ALTER TABLE pieces ADD COLUMN IF NOT EXISTS searchable_text TEXT;

CREATE OR REPLACE FUNCTION public.get_piece_searchable_text(piece_id BIGINT) RETURNS TEXT AS $$
    SELECT 
        CONCAT_WS(' ',
            unaccent(COALESCE(p.work_name, '')),
            unaccent(COALESCE(p.nickname, '')),
            COALESCE(p.catalogue_number::text, ''),
            CASE COALESCE(p.key_signature::text, '')
                WHEN 'csharp' THEN 'C sharp'
                WHEN 'cflat' THEN 'C flat'
                WHEN 'dsharp' THEN 'D sharp'
                WHEN 'dflat' THEN 'D flat'
                WHEN 'esharp' THEN 'E sharp'
                WHEN 'eflat' THEN 'E flat'
                WHEN 'fsharp' THEN 'F sharp'
                WHEN 'fflat' THEN 'F flat'
                WHEN 'gsharp' THEN 'G sharp'
                WHEN 'gflat' THEN 'G flat'
                WHEN 'asharp' THEN 'A sharp'
                WHEN 'aflat' THEN 'A flat'
                WHEN 'bsharp' THEN 'B sharp'
                WHEN 'bflat' THEN 'B flat'
                WHEN 'csharpminor' THEN 'C sharp minor'
                WHEN 'cflatminor' THEN 'C flat minor'
                WHEN 'dsharpminor' THEN 'D sharp minor'
                WHEN 'dflatminor' THEN 'D flat minor'
                WHEN 'esharpminor' THEN 'E sharp minor'
                WHEN 'eflatminor' THEN 'E flat minor'
                WHEN 'fsharpminor' THEN 'F sharp minor'
                WHEN 'fflatminor' THEN 'F flat minor'
                WHEN 'gsharpminor' THEN 'G sharp minor'
                WHEN 'gflatminor' THEN 'G flat minor'
                WHEN 'asharpminor' THEN 'A sharp minor'
                WHEN 'aflatminor' THEN 'A flat minor'
                WHEN 'bsharpminor' THEN 'B sharp minor'
                WHEN 'bflatminor' THEN 'B flat minor'
                WHEN 'cminor' THEN 'C minor'
                WHEN 'dminor' THEN 'D minor'
                WHEN 'eminor' THEN 'E minor'
                WHEN 'fminor' THEN 'F minor'
                WHEN 'gminor' THEN 'G minor'
                WHEN 'aminor' THEN 'A minor'
                WHEN 'bminor' THEN 'B minor'
                WHEN 'c' THEN 'C'
                WHEN 'd' THEN 'D'
                WHEN 'e' THEN 'E'
                WHEN 'f' THEN 'F'
                WHEN 'g' THEN 'G'
                WHEN 'a' THEN 'A'
                WHEN 'b' THEN 'B'
                ELSE ''
            END,
            unaccent(COALESCE(c.name, '')),
            (SELECT COALESCE(string_agg(
                CONCAT_WS(' ', 
                    unaccent(COALESCE(name, '')), 
                    unaccent(COALESCE(nickname, ''))
                ), ' '), '')
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

