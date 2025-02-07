create index if not exists idx_pieces_composer_id on imslp.pieces(composer_id);
create index if not exists idx_movements_piece_id on imslp.movements(piece_id);

