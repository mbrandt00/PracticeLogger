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




ALTER TABLE imslp.movements
ADD CONSTRAINT movements_piece_id_fkey 
FOREIGN KEY (piece_id) 
REFERENCES imslp.pieces(id)
ON DELETE CASCADE;

-- trigger index on insert of piece
CREATE OR REPLACE FUNCTION imslp.trigger_piece_fts() RETURNS trigger AS $$
BEGIN
    UPDATE imslp.pieces
    SET fts = to_tsvector('english', 
                         unaccent(NEW.work_name) || ' ' || 
                         COALESCE(unaccent(regexp_replace(NEW.nickname, '/', ' ', 'g')), ''))
    WHERE imslp.pieces.id = NEW.id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Second trigger for when movements are inserted/updated
CREATE OR REPLACE FUNCTION imslp.trigger_movement_update_piece_fts() RETURNS trigger AS $$
BEGIN
    UPDATE imslp.pieces
    SET fts = to_tsvector('english',
                         unaccent(work_name) || ' ' ||
                         COALESCE(unaccent(regexp_replace(nickname, '/', ' ', 'g')), '') || ' ' ||
                         COALESCE((SELECT string_agg(
                             unaccent(regexp_replace(COALESCE(m.name, ''), '/', ' ', 'g')) || ' ' || 
                             unaccent(regexp_replace(COALESCE(m.nickname, ''), '/', ' ', 'g')), ' ')
                             FROM imslp.movements m 
                             WHERE m.piece_id = NEW.piece_id), ''))
    WHERE id = NEW.piece_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create both triggers
CREATE TRIGGER piece_fts_update
    AFTER INSERT ON imslp.pieces
    FOR EACH ROW
    EXECUTE FUNCTION imslp.trigger_piece_fts();

CREATE TRIGGER movement_update_piece_fts
    AFTER INSERT OR UPDATE ON imslp.movements
    FOR EACH ROW
    EXECUTE FUNCTION imslp.trigger_movement_update_piece_fts();
