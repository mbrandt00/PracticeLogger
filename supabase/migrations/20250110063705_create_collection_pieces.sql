create table if not exists "imslp"."collection_pieces" (
    "collection_id" integer not null,
    "piece_id" integer not null,
    constraint "collection_pieces_pkey" primary key ("collection_id", "piece_id"),
    constraint "collection_pieces_collection_id_fkey" foreign key ("collection_id") 
        references "imslp"."collections"("id"),
    constraint "collection_pieces_piece_id_fkey" foreign key ("piece_id") 
        references "imslp"."pieces"("id")
);
