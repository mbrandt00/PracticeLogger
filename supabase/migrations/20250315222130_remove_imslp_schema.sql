BEGIN;

CREATE TABLE public.collections (
    id bigint primary key,  -- Simple primary key without auto-increment
    name text NOT NULL,
    url text,
    composer_id BIGINT NOT NULL,
    FOREIGN KEY (composer_id) REFERENCES composers(id)
);

INSERT INTO public.collections (id, name, url, composer_id)
SELECT id, name, url, composer_id 
FROM imslp.collections;

CREATE SEQUENCE IF NOT EXISTS collections_id_seq;
SELECT setval('collections_id_seq', (SELECT MAX(id) FROM public.collections));
ALTER TABLE public.collections ALTER COLUMN id SET DEFAULT nextval('collections_id_seq');

ALTER TABLE public.pieces
ADD COLUMN IF NOT EXISTS collection_id BIGINT,
ALTER COLUMN user_id DROP NOT NULL,
ADD CONSTRAINT fk_collection FOREIGN KEY (collection_id) REFERENCES collections(id);

ALTER TABLE public.movements
ADD COLUMN  imslp_piece_id BIGINT;

INSERT INTO public.pieces (work_name, composer_id, nickname, format, key_signature, catalogue_type, catalogue_number, updated_at, created_at, searchable_text, catalogue_type_num_desc, catalogue_number_secondary, composition_year, composition_year_desc, piece_style, wikipedia_url, instrumentation, composition_year_string, sub_piece_type, sub_piece_count, imslp_url, collection_id, imslp_piece_id)
SELECT work_name, composer_id, nickname, format, key_signature, catalogue_type, catalogue_number, updated_at, created_at, searchable_text, catalogue_type_num_desc, catalogue_number_secondary, composition_year, composition_year_desc, piece_style, wikipedia_url, instrumentation, composition_year_string, sub_piece_type, sub_piece_count, imslp_url, collection_id, id
FROM imslp.pieces;


INSERT INTO public.movements (piece_id, name, number, key_signature, nickname, download_url, imslp_piece_id)
SELECT p.id, m.name, m.number, m.key_signature, m.nickname, m.download_url, m.piece_id, m.id
FROM imslp.movements m
JOIN imslp.pieces imslp_p ON m.piece_id = imslp_p.id
JOIN public.pieces p ON p.imslp_piece_id = imslp_p.id

DROP SCHEMA imslp CASCADE;
COMMIT;
