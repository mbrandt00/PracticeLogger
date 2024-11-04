ALTER TABLE pieces ADD COLUMN fts tsvector; -- full text search

CREATE OR REPLACE FUNCTION update_piece_search() RETURNS TRIGGER AS $$
BEGIN
    NEW.fts := to_tsvector('english', NEW.work_name || ' ' ||
                                       COALESCE((SELECT string_agg(m.name, ' ')
                                                 FROM movements m 
                                                 WHERE m.piece_id = NEW.id), '') || ' ' ||
                                       COALESCE((SELECT c.name 
                                                 FROM composers c 
                                                 WHERE c.id = NEW.composer_id), ''));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pieces_search_vector_trigger
BEFORE INSERT OR UPDATE ON pieces
FOR EACH ROW EXECUTE FUNCTION update_piece_search();

CREATE OR REPLACE FUNCTION update_piece_fts(target_id BigInt) RETURNS VOID AS $$ -- for updating after movement info changes
BEGIN
    UPDATE pieces
    SET fts = to_tsvector('english', work_name || ' ' ||
                            COALESCE((SELECT string_agg(m.name, ' ')
                                      FROM movements m
                                      WHERE m.piece_id = target_id), '') || ' ' ||
                            COALESCE((SELECT c.name
                                      FROM composers c
                                      WHERE c.id = (SELECT composer_id FROM pieces WHERE id = target_id)), ''))
    WHERE id = target_id;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

CREATE INDEX pieces_fts ON pieces USING gin (fts);

