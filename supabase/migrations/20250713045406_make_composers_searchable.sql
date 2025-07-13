ALTER TABLE composers
ADD COLUMN searchable_text text,
ADD COLUMN searchable BOOLEAN NOT NULL DEFAULT false;

CREATE OR REPLACE FUNCTION update_composers_searchable_text()
RETURNS TRIGGER AS $$
BEGIN
  NEW.searchable_text := CONCAT(NEW.first_name, ' ', NEW.last_name, ' ', NEW.nationality);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_or_update_on_composers_set_searchable_text
BEFORE INSERT OR UPDATE ON composers
FOR EACH ROW
EXECUTE FUNCTION update_composers_searchable_text();

CREATE OR REPLACE FUNCTION search_composers(query TEXT)
RETURNS SETOF composers AS $$
    WITH terms AS (
        SELECT unnest(string_to_array(lower(unaccent(query)), ' ')) AS term
    )
    SELECT c.*
    FROM composers c
    WHERE c.searchable_text IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM terms
          WHERE lower(c.searchable_text) NOT LIKE '%' || term || '%'
      )
    ORDER BY similarity(c.searchable_text, unaccent(query)) DESC
    LIMIT 25;
$$ LANGUAGE sql STABLE SECURITY DEFINER;
-- trigger for all existing composers
update composers 
set first_name = first_name;
