/** Up Migration **/
alter table imslp.collection_pieces
add column ordering integer,
add column notes text;

create index idx_collection_pieces_ordering on imslp.collection_pieces(collection_id, ordering);

/** Down Migration **/
drop index if exists imslp.idx_collection_pieces_ordering;
alter table imslp.collection_pieces
drop column if exists ordering,
drop column if exists notes;
