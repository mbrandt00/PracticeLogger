ALTER TABLE pieces ADD COLUMN fts tsvector;
CREATE INDEX pieces_fts ON pieces USING gin (fts);



CREATE OR REPLACE FUNCTION update_piece_fts_manual(target_id BIGINT) RETURNS VOID AS $$
BEGIN
raise notice 'inside update_piece_fts, target_id: %', $1;
    UPDATE pieces
    SET fts = to_tsvector('english', 
                           work_name || ' ' || COALESCE(nickname, '') || ' ' || 
                           COALESCE((SELECT string_agg(m.name, ' ') 
                                     FROM movements m 
                                     WHERE m.piece_id = $1), '') || ' ' ||
                           COALESCE(c.name, ''))
    FROM composers c
    WHERE pieces.id = $1;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;



CREATE OR REPLACE FUNCTION search_piece_with_associations(query text) RETURNS setof pieces AS $$
DECLARE
  formatted_query text;
BEGIN
  -- Split the query string into individual terms and join them with the AND operator (&)
  formatted_query := replace(query, ' ', ' & ');  -- Replace spaces with the AND operator
  RETURN QUERY
  SELECT * FROM pieces WHERE fts @@ to_tsquery(formatted_query);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER IMMUTABLE;
