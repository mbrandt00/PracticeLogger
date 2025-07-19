CREATE TABLE IF NOT EXISTS collection_pieces (
    id BIGSERIAL PRIMARY KEY,
    piece_id BIGINT NOT NULL,
    collection_id BIGINT NOT NULL,
    FOREIGN KEY (piece_id) REFERENCES pieces(id),
    FOREIGN KEY (collection_id) REFERENCES collections(id)
);

ALTER TABLE collection_pieces ENABLE ROW LEVEL SECURITY;

CREATE POLICY auth_read_collection_pieces ON collection_pieces FOR
SELECT TO authenticated USING (true);

CREATE POLICY auth_insert_collection_pieces ON collection_pieces FOR
INSERT TO authenticated WITH CHECK (true);

CREATE POLICY auth_update_collection_pieces ON collection_pieces FOR
UPDATE TO authenticated WITH CHECK (true);

ALTER TABLE collections
ADD COLUMN user_id UUID;

ALTER TABLE collections
ADD CONSTRAINT collections_user_id_fkey
FOREIGN KEY (user_id) REFERENCES auth.users(id);

INSERT INTO collection_pieces (piece_id, collection_id)
SELECT id, collection_id
FROM pieces
WHERE collection_id IS NOT NULL;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.constraint_column_usage 
    WHERE table_name = 'pieces' AND column_name = 'collection_id'
  ) THEN
    ALTER TABLE pieces DROP CONSTRAINT fk_collection;
  END IF;
EXCEPTION WHEN undefined_column THEN
  -- Safe to ignore
END;
$$;

ALTER TABLE pieces DROP COLUMN IF EXISTS collection_id;

CREATE UNIQUE INDEX unique_piece_collection ON collection_pieces (piece_id, collection_id);

ALTER TABLE collection_pieces ADD COLUMN position INTEGER NOT NULL;

CREATE UNIQUE INDEX unique_collection_position ON collection_pieces (collection_id, position);

-- Populate position field
WITH ranked AS (
  SELECT
    cp.id,
    ROW_NUMBER() OVER (
      PARTITION BY cp.collection_id
      ORDER BY p.catalogue_number NULLS LAST
    ) AS row_num
  FROM collection_pieces cp
  JOIN pieces p ON p.id = cp.piece_id
)
UPDATE collection_pieces cp
SET position = ranked.row_num
FROM ranked
WHERE cp.id = ranked.id;

-- Make composer_id optional on collections
ALTER TABLE collections
ALTER COLUMN composer_id DROP NOT NULL;

-- Function: pieces(public.collections)
CREATE OR REPLACE FUNCTION pieces("collection" public.collections)
RETURNS SETOF public.pieces
LANGUAGE SQL
STABLE
AS $$
    SELECT DISTINCT ON (COALESCE(user_piece.imslp_url, default_piece.imslp_url))
        COALESCE(user_piece, default_piece) AS piece
    FROM 
        public.collection_pieces cp
    JOIN 
        public.pieces default_piece ON cp.piece_id = default_piece.id
    LEFT JOIN 
        public.pieces user_piece 
        ON user_piece.imslp_url = default_piece.imslp_url
        AND user_piece.user_id = auth.uid()
        AND user_piece.user_id IS NOT NULL
    WHERE 
        cp.collection_id = "collection".id
    ORDER BY 
        COALESCE(user_piece.imslp_url, default_piece.imslp_url), 
        user_piece.id DESC NULLS LAST,
        cp.position;
$$;

-- GraphQL function metadata
COMMENT ON FUNCTION pieces("collection" public.collections) IS
'@graphql({
  "name": "pieces",
  "description": "Returns pieces belonging to this collection, prioritizing user-customized pieces over default pieces with the same IMSLP URL",
  "totalCount": {"enabled": true}
})';

-- GraphQL relationship metadata for collection_pieces → pieces
COMMENT ON CONSTRAINT collection_pieces_piece_id_fkey ON public.collection_pieces IS 
'@graphql({
  "foreign_name": "piece",
  "local_name": "collectionPieces"
})';

-- GraphQL relationship metadata for collection_pieces → collections
COMMENT ON CONSTRAINT collection_pieces_collection_id_fkey ON public.collection_pieces IS 
'@graphql({
  "foreign_name": "collection",
  "local_name": "collectionPieces"
})';

-- Table metadata for collection_pieces
COMMENT ON TABLE public.collection_pieces IS
'@graphql({
  "description": "Join table linking pieces to collections with optional position ordering",
  "totalCount": {"enabled": true}
})';

-- Table metadata for pieces
COMMENT ON TABLE public.pieces IS
'@graphql({
  "name": "Piece",
  "description": "Represents a musical piece"
})';


CREATE OR REPLACE FUNCTION collections(p public.pieces)
RETURNS SETOF public.collections
LANGUAGE SQL
STABLE
AS $$
  SELECT DISTINCT c.*
  FROM public.collection_pieces cp
  JOIN public.pieces dp ON cp.piece_id = dp.id
  JOIN public.collections c ON cp.collection_id = c.id
  WHERE
    -- Match by direct piece_id
    dp.id = p.id

    -- OR: fallback to shared imslp_url if present
    OR (
      p.imslp_url IS NOT NULL
      AND dp.imslp_url = p.imslp_url
    )
$$;


COMMENT ON FUNCTION collections(p public.pieces) IS
'@graphql({
  "name": "collections",
  "description": "All collections this piece belongs to, based on shared IMSLP URL"
})';
