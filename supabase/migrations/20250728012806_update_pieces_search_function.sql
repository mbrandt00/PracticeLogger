CREATE OR REPLACE FUNCTION search_pieces(
    query text
) 
RETURNS SETOF pieces AS $$
    WITH terms AS (
        SELECT unnest(string_to_array(lower(unaccent(query)), ' ')) as term
    )
    SELECT p.*
    FROM pieces p
    WHERE p.searchable_text IS NOT NULL
      AND (
          SELECT bool_and(lower(p.searchable_text) LIKE '%' || term || '%')
          FROM terms
      )
    ORDER BY similarity(p.searchable_text, unaccent(query)) DESC
    LIMIT 25
$$ LANGUAGE sql STABLE SECURITY DEFINER;
