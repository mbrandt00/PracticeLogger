/** Up Migration **/
create index if not exists idx_pieces_composer_id on imslp.pieces(composer_id);
create index if not exists idx_movements_piece_id on imslp.movements(piece_id);
create index if not exists idx_collection_pieces_piece_id on imslp.collection_pieces(piece_id);
create index if not exists idx_collection_pieces_collection_id on imslp.collection_pieces(collection_id);

/** Down Migration **/
drop index if exists imslp.idx_pieces_composer_id;
drop index if exists imslp.idx_movements_piece_id;
drop index if exists imslp.idx_collection_pieces_piece_id;
drop index if exists imslp.idx_collection_pieces_collection_id;
