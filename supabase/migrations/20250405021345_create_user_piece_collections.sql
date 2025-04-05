CREATE OR REPLACE VIEW collection_pieces_with_fallback AS
SELECT DISTINCT ON (COALESCE(user_piece.imslp_url, default_piece.imslp_url)) 
    COALESCE(user_piece.id, default_piece.id) AS piece_id,
    COALESCE(user_piece.work_name, default_piece.work_name) AS work_name,
    COALESCE(user_piece.catalogue_number, default_piece.catalogue_number) AS catalogue_number,
    user_piece.user_id AS user_id,
    c.id AS collection_id,
    composers.id AS composer_id
FROM 
    public.collections c
LEFT JOIN 
    public.pieces default_piece ON default_piece.collection_id = c.id
LEFT JOIN 
    public.pieces user_piece 
        ON user_piece.collection_id = c.id 
        AND user_piece.user_id = auth.uid()
        AND user_piece.imslp_url = default_piece.imslp_url
LEFT JOIN 
    public.composers ON c.composer_id = composers.id
ORDER BY 
    COALESCE(user_piece.imslp_url, default_piece.imslp_url),
    COALESCE(user_piece.catalogue_number, default_piece.catalogue_number);

-- Add pg_graphql comment to define primary key for the view (required for views)
COMMENT ON VIEW collection_pieces_with_fallback IS
  E'@graphql({
    "primary_key_columns": ["piece_id"],
    "name": "collectionPiecesWithFallback",
    "totalCount": {"enabled": true},
    "foreign_keys": [
      {
        "local_columns": ["composer_id"],
        "foreign_schema": "public",
        "foreign_table": "composers",
        "foreign_columns": ["id"],
        "foreign_name": "composer"
      },
      {
        "local_columns": ["piece_id"],
        "foreign_schema": "public", 
        "foreign_table": "pieces",
        "foreign_columns": ["id"],
        "foreign_name": "piece"
      },
      {
        "local_columns": ["collection_id"],
        "foreign_schema": "public",
        "foreign_table": "collections",
        "foreign_columns": ["id"],
        "foreign_name": "collection"
      }
    ]
  })';
