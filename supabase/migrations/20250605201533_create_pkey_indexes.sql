CREATE INDEX idx_collections_composer_id ON collections (composer_id);
CREATE INDEX movements_piece_id_idx ON movements (piece_id);
CREATE INDEX idx_fk_collection ON pieces (collection_id);
CREATE INDEX pieces_composer_id_idx ON pieces (composer_id);
CREATE INDEX pieces_user_id_idx ON pieces (user_id);
CREATE INDEX practice_sessions_movement_id_idx ON practice_sessions (movement_id);
CREATE INDEX practice_sessions_piece_id_idx ON practice_sessions (piece_id);
CREATE INDEX practice_sessions_user_id_idx ON practice_sessions (user_id);

-- unused index
DROP INDEX IF EXISTS idx_pieces_searchable_text_trgm;
