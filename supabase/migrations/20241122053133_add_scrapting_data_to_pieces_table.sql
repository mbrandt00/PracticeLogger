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
comment on schema imslp is e'@graphql({"inflect_names": true})';

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

ALTER TABLE imslp.pieces
ADD CONSTRAINT composers_piece_id_fkey 
FOREIGN KEY (composer_id) 
REFERENCES composers(id)
ON DELETE SET NULL;
--search

CREATE OR REPLACE FUNCTION imslp.get_piece_searchable_text(piece_id BIGINT) RETURNS TEXT AS $$
    SELECT 
        CONCAT_WS(' ',
            unaccent(COALESCE(p.work_name, '')),
            unaccent(COALESCE(p.nickname, '')),
            COALESCE(p.catalogue_type::text, ''),
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


ALTER SCHEMA imslp OWNER TO postgres;
GRANT USAGE ON SCHEMA imslp TO postgres, anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA imslp TO postgres, anon, authenticated;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA imslp TO postgres, anon, authenticated;

CREATE OR REPLACE FUNCTION imslp.refresh_all_searchable_text() 
RETURNS void AS $$
BEGIN
    UPDATE imslp.pieces 
    SET searchable_text = imslp.get_piece_searchable_text(id);
END;
$$ LANGUAGE plpgsql;