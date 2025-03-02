-- Migration to enhance search to handle apostrophes in both schemas

-- 1. Update the public schema function to remove apostrophes from text
CREATE OR REPLACE FUNCTION public.get_piece_searchable_text(piece_id BIGINT) RETURNS TEXT AS $$
    SELECT 
        CONCAT_WS(' ',
            unaccent(REPLACE(COALESCE(p.work_name, ''), '''', '')),
            unaccent(REPLACE(COALESCE(p.nickname, ''), '''', '')),
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
            unaccent(REPLACE(COALESCE(c.name, ''), '''', '')),
            (SELECT COALESCE(string_agg(
                CONCAT_WS(' ', 
                    unaccent(REPLACE(COALESCE(name, ''), '''', '')), 
                    unaccent(REPLACE(COALESCE(nickname, ''), '''', ''))
                ), ' '), '')
             FROM movements 
             WHERE piece_id = $1)
        )
    FROM pieces p
    LEFT JOIN composers c ON c.id = p.composer_id
    WHERE p.id = piece_id;
$$ LANGUAGE sql SECURITY DEFINER;

-- 2. Update the public search function to handle apostrophes in queries
CREATE OR REPLACE FUNCTION search_user_pieces(
    query text
) 
RETURNS SETOF pieces AS $$
    WITH terms AS (
        SELECT unnest(string_to_array(lower(unaccent(REPLACE(query, '''', ''))), ' ')) as term
    )
    SELECT p.*
    FROM pieces p
    WHERE searchable_text IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM terms
        WHERE lower(p.searchable_text) NOT LIKE '%' || term || '%'
    )
    AND p.user_id = auth.uid()
    ORDER BY similarity(p.searchable_text, unaccent(REPLACE(query, '''', ''))) DESC
    LIMIT 25
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- 3. Update the IMSLP schema function to remove apostrophes from text
CREATE OR REPLACE FUNCTION imslp.get_piece_searchable_text(piece_id BIGINT) RETURNS TEXT AS $$
    SELECT 
        CONCAT_WS(' ',
            unaccent(REPLACE(COALESCE(p.work_name, ''), '''', '')),
            unaccent(REPLACE(COALESCE(p.nickname, ''), '''', '')),
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
            unaccent(REPLACE(COALESCE(c.name, ''), '''', '')),
            (SELECT COALESCE(string_agg(
                CONCAT_WS(' ', 
                    unaccent(REPLACE(COALESCE(name, ''), '''', '')), 
                    unaccent(REPLACE(COALESCE(nickname, ''), '''', ''))
                ), ' '), '')
             FROM imslp.movements 
             WHERE piece_id = $1)
        )
    FROM imslp.pieces p
    LEFT JOIN composers c ON c.id = p.composer_id
    WHERE p.id = piece_id;
$$ LANGUAGE sql SECURITY DEFINER;

-- 4. Update the IMSLP search function to handle apostrophes in queries
CREATE OR REPLACE FUNCTION imslp.search_imslp_pieces(query text, filter_user_pieces boolean DEFAULT false) 
RETURNS SETOF imslp.pieces AS $$
    WITH terms AS (
        SELECT unnest(string_to_array(lower(unaccent(REPLACE(query, '''', ''))), ' ')) as term
    )
    SELECT p.*
    FROM imslp.pieces p
    WHERE searchable_text IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM terms
        WHERE lower(p.searchable_text) NOT LIKE '%' || term || '%'
    )
    AND (
        NOT filter_user_pieces 
        OR NOT EXISTS (
            SELECT 1 
            FROM public.pieces up 
            WHERE up.imslp_piece_id = p.id 
            AND up.user_id = auth.uid()
        )
    )
    ORDER BY similarity(p.searchable_text, unaccent(REPLACE(query, '''', ''))) DESC
    LIMIT 25;
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- 5. Update all existing pieces in both schemas to reflect the new searchable text format

-- Helper function for public schema
CREATE OR REPLACE FUNCTION update_piece_searchable_text_now(piece_id BIGINT) 
RETURNS VOID 
SECURITY DEFINER AS $$
DECLARE
    new_text TEXT;
BEGIN
    -- Get the new searchable text
    SELECT get_piece_searchable_text(piece_id) INTO new_text;
    
    -- Update the piece's searchable text
    UPDATE pieces 
    SET searchable_text = new_text
    WHERE id = piece_id;
END;
$$ LANGUAGE plpgsql;

-- Helper function for IMSLP schema
CREATE OR REPLACE FUNCTION imslp.update_piece_searchable_text_now(piece_id BIGINT) 
RETURNS VOID 
SECURITY DEFINER AS $$
DECLARE
    new_text TEXT;
BEGIN
    -- Get the new searchable text
    SELECT imslp.get_piece_searchable_text(piece_id) INTO new_text;
    
    -- Update the piece's searchable text
    UPDATE imslp.pieces 
    SET searchable_text = new_text
    WHERE id = piece_id;
END;
$$ LANGUAGE plpgsql;

-- Update all existing pieces in both schemas
DO $$
DECLARE
    public_piece_record RECORD;
    imslp_piece_record RECORD;
BEGIN
    -- Update public schema pieces
    FOR public_piece_record IN SELECT id FROM pieces
    LOOP
        PERFORM update_piece_searchable_text_now(public_piece_record.id);
    END LOOP;
    
    -- Update IMSLP schema pieces
    FOR imslp_piece_record IN SELECT id FROM imslp.pieces
    LOOP
        PERFORM imslp.update_piece_searchable_text_now(imslp_piece_record.id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Once all pieces are updated, drop the helper functions
DROP FUNCTION IF EXISTS update_piece_searchable_text_now;
DROP FUNCTION IF EXISTS imslp.update_piece_searchable_text_now;
