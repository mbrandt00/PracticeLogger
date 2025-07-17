CREATE TABLE IF NOT EXISTS collection_pieces (
    id BIGSERIAL PRIMARY KEY,
    piece_id BIGINT NOT NULL,
    collection_id BIGINT NOT NULL,
    FOREIGN KEY (piece_id) REFERENCES pieces(id),
    FOREIGN KEY (collection_ID) REFERENCES collections(id)
);
-- Enable RLS
ALTER TABLE collection_pieces ENABLE ROW LEVEL SECURITY;

CREATE POLICY auth_read_collection_pieces ON collection_pieces FOR
SELECT TO authenticated USING (true);
CREATE POLICY auth_insert_collection_pieces ON collection_pieces FOR
INSERT TO authenticated WITH CHECK (true);
CREATE POLICY auth_update_collection_pieces ON collection_pieces FOR
UPDATE TO authenticated WITH CHECK (true);

ALTER TABLE collections
ADD COLUMN user_id UUID,
ADD CONSTRAINT collections_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES auth.users(id);

-- Backfill from existing pieces
INSERT INTO collection_pieces (piece_id, collection_id)
SELECT id, collection_id
FROM pieces
WHERE collection_id IS NOT NULL;

ALTER TABLE pieces
DROP CONSTRAINT fk_collection;  -- if constraint exists

ALTER TABLE pieces
DROP COLUMN collection_id;

CREATE UNIQUE INDEX unique_piece_collection ON collection_pieces (piece_id, collection_id);

-- add order and backfill
ALTER TABLE collection_pieces
ADD COLUMN position INTEGER;

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

