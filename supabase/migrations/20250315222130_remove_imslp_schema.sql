BEGIN;

-- Step 1: Add columns to pieces and movements
ALTER TABLE public.pieces
ADD COLUMN is_imslp boolean DEFAULT false,
ADD COLUMN collection_id bigint;  -- Adding collection_id to pieces

ALTER TABLE public.movements
ADD COLUMN is_imslp boolean DEFAULT false,
ADD COLUMN imslp_movement_id bigint;

-- Step 2: Create the collections table in the public schema
CREATE TABLE public.collections (
    id bigint primary key,  -- Simple primary key without auto-increment
    name text NOT NULL,
    url text,
    composer_id BIGINT NOT NULL,
    FOREIGN KEY (composer_id) REFERENCES composers(id)
);

-- Step 3: Insert data from imslp.collections into public.collections
INSERT INTO public.collections (id, name, url, composer_id)
SELECT id, name, url, composer_id 
FROM imslp.collections;

-- After importing the data, add a sequence and set it to start after the highest ID
CREATE SEQUENCE IF NOT EXISTS collections_id_seq;
SELECT setval('collections_id_seq', (SELECT MAX(id) FROM public.collections));
ALTER TABLE public.collections ALTER COLUMN id SET DEFAULT nextval('collections_id_seq');

-- Make user_id nullable to allow import of pieces without users
ALTER TABLE public.pieces ALTER COLUMN user_id DROP NOT NULL;

-- Step 4: Insert data into public.pieces from imslp.pieces
INSERT INTO public.pieces (work_name, composer_id, nickname, format, key_signature, catalogue_type, catalogue_number, updated_at, created_at, searchable_text, catalogue_type_num_desc, catalogue_number_secondary, composition_year, composition_year_desc, piece_style, wikipedia_url, instrumentation, composition_year_string, sub_piece_type, sub_piece_count, imslp_url, collection_id, is_imslp)
SELECT work_name, composer_id, nickname, format, key_signature, catalogue_type, catalogue_number, updated_at, created_at, searchable_text, catalogue_type_num_desc, catalogue_number_secondary, composition_year, composition_year_desc, piece_style, wikipedia_url, instrumentation, composition_year_string, sub_piece_type, sub_piece_count, imslp_url, collection_id, true
FROM imslp.pieces;

ALTER TABLE public.movements ADD COLUMN is_imslp boolean DEFAULT false;
-- Step 5: Insert data into public.movements from imslp.movements with proper piece_id mapping
INSERT INTO public.movements (piece_id, name, number, key_signature, nickname, download_url, is_imslp)
SELECT p.id, m.name, m.number, m.key_signature, m.nickname, m.download_url, true
FROM imslp.movements m
JOIN public.pieces p ON m.piece_id = p.imslp_piece_id

COMMIT;

DROP SCHEMA imslp CASCADE;
