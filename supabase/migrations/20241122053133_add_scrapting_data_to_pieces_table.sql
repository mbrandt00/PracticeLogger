ALTER TABLE pieces
ADD COLUMN catalogue_type_num_desc text,
ADD COLUMN composition_year int,
ADD COLUMN composition_year_desc text,
ADD COLUMN piece_style text,
ADD COLUMN wikipedia_url text,
ADD COLUMN instrumentation text[],
DROP COLUMN tonality CASCADE;


