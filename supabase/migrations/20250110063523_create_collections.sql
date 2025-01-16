create table if not exists "imslp"."collections" (
    "id" integer not null,
    "name" character varying(255) not null,
    "url" character varying(1024),
    "composer_id" integer,
    constraint "collections_pkey" primary key ("id"),
    constraint "collections_name_composer_id_key" unique ("name", "composer_id"),
    constraint "collections_composer_id_fkey" foreign key ("composer_id") 
        references "public"."composers"("id")
);

create sequence if not exists "imslp"."collections_id_seq"
    as integer
    start with 1
    increment by 1
    no minvalue
    no maxvalue
    cache 1;

alter sequence "imslp"."collections_id_seq" owned by "imslp"."collections"."id";

alter table only "imslp"."collections" alter column "id" 
    set default nextval('imslp.collections_id_seq'::regclass);

ALTER TABLE imslp.pieces
ADD COLUMN collection_id BIGINT,
ADD CONSTRAINT fk_imslp_pieces_to_collection
FOREIGN KEY (collection_id) REFERENCES imslp.collections(id);

COMMENT ON CONSTRAINT fk_imslp_pieces_to_collection 
  ON imslp.pieces 
  IS E'@graphql({"foreign_name": "collection", "local_name": "pieces"})';
