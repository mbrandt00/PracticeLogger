/** Up Migration **/
CREATE TABLE IF NOT EXISTS "imslp"."collection_pieces" (
    "collection_id" integer NOT NULL,
    "piece_id" integer NOT NULL
);

create type imslp.collection_type as enum (
    'opus_group',
    'thematic_group',
    'publication',
    'cycle',
    'series'
);

alter table imslp.collections 
add column collection_type imslp.collection_type,
add column parent_collection_id integer references imslp.collections(id),
add column publication_year integer,
add column description text,
add column ordering integer;

/** Down Migration **/
alter table imslp.collections 
drop column if exists collection_type,
drop column if exists parent_collection_id,
drop column if exists publication_year,
drop column if exists description,
drop column if exists ordering;

drop type if exists imslp.collection_type;
