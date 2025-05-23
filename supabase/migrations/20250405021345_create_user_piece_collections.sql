CREATE OR REPLACE FUNCTION pieces("collection" public.collections)
RETURNS SETOF public.pieces
LANGUAGE SQL
STABLE
AS $$
    SELECT DISTINCT ON (COALESCE(user_piece.imslp_url, default_piece.imslp_url))
        COALESCE(user_piece, default_piece) AS piece
    FROM 
        public.pieces default_piece
    LEFT JOIN 
        public.pieces user_piece 
        ON user_piece.imslp_url = default_piece.imslp_url
        AND user_piece.collection_id = default_piece.collection_id
        AND user_piece.user_id = auth.uid()
    WHERE 
        default_piece.collection_id = "collection".id
    ORDER BY COALESCE(user_piece.imslp_url, default_piece.imslp_url), user_piece.id DESC NULLS LAST;
$$;

-- Add pg_graphql comment for the function
COMMENT ON FUNCTION pieces("collection" public.collections) IS
  E'@graphql({
    "name": "pieces",
    "description": "Returns pieces belonging to this collection, prioritizing user-customized pieces over default pieces with the same IMSLP URL",
    "totalCount": {"enabled": true}
  })';

COMMENT ON SCHEMA public IS e'@graphql({
    "inflect_names": true,
    "name": "public",
    "max_rows": 1000
})';

