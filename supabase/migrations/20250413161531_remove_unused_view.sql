drop view public.user_unique_piece_sessions_v;

ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
CREATE POLICY auth_read_collections ON collections FOR
SELECT TO authenticated USING (true);

CREATE OR REPLACE FUNCTION refresh_all_searchable_text() 
RETURNS void AS $$
BEGIN
    UPDATE pieces 
    SET searchable_text = get_piece_searchable_text(id);
END;
$$ LANGUAGE plpgsql;

CREATE UNIQUE INDEX index_pieces_on_imslp_url_and_user_id
ON public.pieces (imslp_url, user_id);

CREATE UNIQUE INDEX index_pieces_on_collection_id
ON public.pieces (imslp_url, user_id);

CREATE UNIQUE INDEX index_collections_on_name_and_composer_id
ON collections (name, composer_id);
