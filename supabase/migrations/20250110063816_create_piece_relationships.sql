/** Up Migration **/
create table if not exists imslp.piece_relationships (
    id serial primary key,
    source_piece_id integer references imslp.pieces(id) on delete cascade,
    target_piece_id integer references imslp.pieces(id) on delete cascade,
    relationship_type varchar(50) not null,
    notes text,
    created_at timestamptz default current_timestamp,
    unique(source_piece_id, target_piece_id, relationship_type),
    constraint prevent_self_reference check (source_piece_id != target_piece_id)
);

create index idx_piece_relationships_source on imslp.piece_relationships(source_piece_id);
create index idx_piece_relationships_target on imslp.piece_relationships(target_piece_id);

/** Down Migration **/
drop table if exists imslp.piece_relationships;
