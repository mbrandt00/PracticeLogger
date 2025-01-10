create table if not exists "imslp"."collections" (
    "id" integer not null,
    "name" character varying(255) not null,
    "url" character varying(1024),
    "composer_id" integer,
    constraint "collections_pkey" primary key ("id"),
    constraint "collections_url_key" unique ("url"),
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
    set default nextval('imslp.collections_id_seq'::regclass)
