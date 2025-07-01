ALTER TABLE collections
ADD COLUMN searchable_text text,
ADD COLUMN searchable BOOLEAN NOT NULL DEFAULT false;

CREATE OR REPLACE FUNCTION update_collections_searchable_text()
RETURNS TRIGGER AS $$
DECLARE
    composer_name TEXT;
BEGIN
  SELECT CONCAT(first_name, ' ', last_name) INTO composer_name
  FROM composers
  WHERE id = NEW.composer_id;

  NEW.searchable_text := CONCAT(NEW.name, ' ', COALESCE(composer_name, ''));

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_or_update_on_collections_set_searchable_text
BEFORE INSERT OR UPDATE ON collections
FOR EACH ROW
EXECUTE FUNCTION update_collections_searchable_text();

CREATE OR REPLACE FUNCTION search_collections(query TEXT)
RETURNS SETOF collections AS $$
    WITH terms AS (
        SELECT unnest(string_to_array(lower(unaccent(query)), ' ')) AS term
    )
    SELECT c.*
    FROM collections c
    WHERE c.searchable_text IS NOT NULL AND searchable = true
      AND NOT EXISTS (
          SELECT 1 FROM terms
          WHERE lower(c.searchable_text) NOT LIKE '%' || term || '%'
      )
    ORDER BY similarity(c.searchable_text, unaccent(query)) DESC
    LIMIT 25;
$$ LANGUAGE sql STABLE SECURITY DEFINER;
