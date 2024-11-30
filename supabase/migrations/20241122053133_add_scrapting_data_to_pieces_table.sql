ALTER TABLE pieces
ADD COLUMN catalogue_type_num_desc text,
ADD COLUMN catalogue_number_secondary INT,
ADD COLUMN composition_year int,
ADD COLUMN composition_year_desc text,
ADD COLUMN piece_style text,
ADD COLUMN wikipedia_url text,
ADD COLUMN instrumentation text[],
ADD COLUMN composition_year_string text,
ADD COLUMN sub_piece_type text,
ADD COLUMN sub_piece_count INT,
ADD COLUMN imslp_url text;

ALTER TABLE movements
ADD COLUMN key_signature key_signature_type,
ADD COLUMN nickname text,
ADD COLUMN download_url text;

CREATE SCHEMA IF NOT EXISTS imslp;
CREATE TABLE imslp.pieces (LIKE public.pieces INCLUDING ALL);
ALTER TABLE imslp.pieces DROP COLUMN user_id;
CREATE TABLE imslp.movements (LIKE public.movements INCLUDING ALL);



-- Add the correct foreign key constraint pointing to imslp.pieces
ALTER TABLE imslp.movements
ADD CONSTRAINT movements_piece_id_fkey 
FOREIGN KEY (piece_id) 
REFERENCES imslp.pieces(id);

