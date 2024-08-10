CREATE OR REPLACE FUNCTION search_pieces_f(pieces_row pieces) RETURNS text AS $$
BEGIN
  RETURN coalesce(pieces_row.work_name, '') || ' ' ||
         coalesce(pieces_row.nickname, '') || ' ' ||
         coalesce((SELECT name FROM composers WHERE id = pieces_row.composer_id), '');
END;
$$ LANGUAGE plpgsql IMMUTABLE;