
CREATE OR REPLACE FUNCTION search_pieces(
    query text
) 
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
    ORDER BY similarity(p.searchable_text, unaccent(query)) DESC
    LIMIT 25
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- DROP FUNCTION search_user_pieces;
