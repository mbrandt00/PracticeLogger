ALTER TABLE pieces
ADD COLUMN catalogue_type_num_desc text,
ADD COLUMN catalogue_number_secondary INT,
ADD COLUMN composition_year int,
ADD COLUMN composition_year_desc text,
ADD COLUMN piece_style text,
ADD COLUMN wikipedia_url text,
ADD COLUMN instrumentation text[],
ADD COLUMN composition_year_string text,
ADD COLUMN sub_piece_type text,
ADD COLUMN sub_piece_count INT,
ADD COLUMN imslp_url text;

ALTER TABLE movements
ADD COLUMN key_signature key_signature_type,
ADD COLUMN nickname text,
ADD COLUMN download_url text;

CREATE SCHEMA IF NOT EXISTS imslp;
comment on schema public is e'@graphql({"inflect_names": true})';

CREATE TABLE imslp.pieces (LIKE public.pieces INCLUDING ALL);
ALTER TABLE imslp.pieces DROP COLUMN user_id;
CREATE TABLE imslp.movements (LIKE public.movements INCLUDING ALL);

ALTER TABLE pieces
ADD COLUMN imslp_piece_id BIGINT,
ADD CONSTRAINT fk_imslp_piece
FOREIGN KEY (imslp_piece_id) REFERENCES imslp.pieces(id)
ON DELETE SET NULL;

ALTER TABLE imslp.movements
ADD CONSTRAINT movements_piece_id_fkey 
FOREIGN KEY (piece_id) 
REFERENCES imslp.pieces(id)
ON DELETE CASCADE;

--search

CREATE OR REPLACE FUNCTION imslp.get_piece_searchable_text(piece_id BIGINT) RETURNS TEXT AS $$
    SELECT 
        CONCAT_WS(' ',
            unaccent(p.work_name),
            unaccent(p.nickname),
            unaccent(c.name),
            (SELECT string_agg(unaccent(name) || ' ' || COALESCE(unaccent(nickname), ''), ' ')
             FROM imslp.movements 
             WHERE piece_id = $1)
        )
    FROM imslp.pieces p
    LEFT JOIN composers c ON c.id = p.composer_id
    WHERE p.id = piece_id;
$$ LANGUAGE sql SECURITY DEFINER;

-- Create index for faster searching
CREATE INDEX IF NOT EXISTS idx_pieces_searchable_text_trgm 
ON imslp.pieces USING gin (searchable_text gin_trgm_ops);

-- Main search function
CREATE OR REPLACE FUNCTION imslp.search_imslp_pieces(query text) 
RETURNS SETOF imslp.pieces AS $$
    WITH terms AS (
        SELECT unnest(string_to_array(lower(unaccent(query)), ' ')) as term
    )
    SELECT p.*
    FROM imslp.pieces p
    WHERE searchable_text IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM terms
        WHERE lower(p.searchable_text) NOT LIKE '%' || term || '%'
    )
    ORDER BY similarity(p.searchable_text, unaccent(query)) DESC;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION imslp.update_piece_searchable_text() RETURNS trigger AS $$
BEGIN
    NEW.searchable_text := imslp.get_piece_searchable_text(NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER piece_searchable_text_update
    BEFORE INSERT OR UPDATE ON imslp.pieces
    FOR EACH ROW
    EXECUTE FUNCTION imslp.update_piece_searchable_text();

CREATE OR REPLACE FUNCTION imslp.update_movement_piece_searchable_text() RETURNS trigger AS $$
BEGIN
    UPDATE imslp.pieces
    SET searchable_text = imslp.get_piece_searchable_text(
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
    AFTER INSERT OR UPDATE OR DELETE ON imslp.movements
    FOR EACH ROW
    EXECUTE FUNCTION imslp.update_movement_piece_searchable_text();

GRANT USAGE ON SCHEMA imslp TO authenticated, service_role;

-- For authenticated users (more restricted)
GRANT SELECT ON ALL TABLES IN SCHEMA imslp TO authenticated;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA imslp TO authenticated;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA imslp TO authenticated;

-- For service_role (internal services, more permissive)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA imslp TO service_role;
GRANT ALL PRIVILEGES ON ALL ROUTINES IN SCHEMA imslp TO service_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA imslp TO service_role;

-- Set default privileges for future objects
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA imslp 
    GRANT SELECT ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA imslp 
    GRANT ALL ON TABLES TO service_role;

ALTER DATABASE postgres SET search_path TO public,imslp;

