BEGIN;

ALTER TABLE composers
ADD COLUMN first_name TEXT,
ADD COLUMN last_name TEXT,
ADD COLUMN nationality TEXT,
ADD COLUMN musical_era TEXT,
ADD COLUMN user_id UUID,
ADD CONSTRAINT composers_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES auth.users(id)
    ON DELETE CASCADE;

-- 2. Populate first_name and last_name by splitting on the comma
UPDATE composers
SET
    last_name = split_part(name, ',', 1),
    first_name = ltrim(split_part(name, ',', 2));

-- 3. Enforce NOT NULL constraint after data has been migrated
ALTER TABLE composers
ALTER COLUMN first_name SET NOT NULL,
ALTER COLUMN last_name SET NOT NULL;

-- 4. (Optional) Drop the old `name` column
ALTER TABLE composers
DROP COLUMN name;

COMMIT;


CREATE OR REPLACE FUNCTION find_or_create_composer(
    first_name TEXT,
    last_name TEXT
) RETURNS composers AS $$
DECLARE
    composer_record composers;
BEGIN
    -- Try to find a composer by first and last name
    SELECT * INTO composer_record
    FROM composers
    WHERE composers.first_name = find_or_create_composer.first_name
      AND composers.last_name = find_or_create_composer.last_name;

    -- If not found, insert a new composer
    IF NOT FOUND THEN
        INSERT INTO composers (first_name, last_name)
        VALUES (find_or_create_composer.first_name, find_or_create_composer.last_name)
        RETURNING * INTO composer_record;
    END IF;

    -- Return the composer record
    RETURN composer_record;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.get_piece_searchable_text(piece_id BIGINT) RETURNS TEXT AS $$
    SELECT 
        CONCAT_WS(' ',
            unaccent(COALESCE(p.work_name, '')),
            unaccent(COALESCE(p.nickname, '')),
            COALESCE(p.catalogue_number::text, ''),
            CASE COALESCE(p.key_signature::text, '')
                WHEN 'csharp' THEN 'C sharp'
                WHEN 'cflat' THEN 'C flat'
                WHEN 'dsharp' THEN 'D sharp'
                WHEN 'dflat' THEN 'D flat'
                WHEN 'esharp' THEN 'E sharp'
                WHEN 'eflat' THEN 'E flat'
                WHEN 'fsharp' THEN 'F sharp'
                WHEN 'fflat' THEN 'F flat'
                WHEN 'gsharp' THEN 'G sharp'
                WHEN 'gflat' THEN 'G flat'
                WHEN 'asharp' THEN 'A sharp'
                WHEN 'aflat' THEN 'A flat'
                WHEN 'bsharp' THEN 'B sharp'
                WHEN 'bflat' THEN 'B flat'
                WHEN 'csharpminor' THEN 'C sharp minor'
                WHEN 'cflatminor' THEN 'C flat minor'
                WHEN 'dsharpminor' THEN 'D sharp minor'
                WHEN 'dflatminor' THEN 'D flat minor'
                WHEN 'esharpminor' THEN 'E sharp minor'
                WHEN 'eflatminor' THEN 'E flat minor'
                WHEN 'fsharpminor' THEN 'F sharp minor'
                WHEN 'fflatminor' THEN 'F flat minor'
                WHEN 'gsharpminor' THEN 'G sharp minor'
                WHEN 'gflatminor' THEN 'G flat minor'
                WHEN 'asharpminor' THEN 'A sharp minor'
                WHEN 'aflatminor' THEN 'A flat minor'
                WHEN 'bsharpminor' THEN 'B sharp minor'
                WHEN 'bflatminor' THEN 'B flat minor'
                WHEN 'cminor' THEN 'C minor'
                WHEN 'dminor' THEN 'D minor'
                WHEN 'eminor' THEN 'E minor'
                WHEN 'fminor' THEN 'F minor'
                WHEN 'gminor' THEN 'G minor'
                WHEN 'aminor' THEN 'A minor'
                WHEN 'bminor' THEN 'B minor'
                WHEN 'c' THEN 'C'
                WHEN 'd' THEN 'D'
                WHEN 'e' THEN 'E'
                WHEN 'f' THEN 'F'
                WHEN 'g' THEN 'G'
                WHEN 'a' THEN 'A'
                WHEN 'b' THEN 'B'
                ELSE ''
            END,
            CONCAT_WS(' ',
                unaccent(COALESCE(c.first_name, '')),
                unaccent(COALESCE(c.last_name, ''))
            ),
            (SELECT COALESCE(string_agg(
                CONCAT_WS(' ', 
                    unaccent(COALESCE(name, '')), 
                    unaccent(COALESCE(nickname, ''))
                ), ' '), '')
             FROM movements 
             WHERE piece_id = $1)
        )
    FROM pieces p
    LEFT JOIN composers c ON c.id = p.composer_id
    WHERE p.id = piece_id;
$$ LANGUAGE sql SECURITY DEFINER;

CREATE POLICY "Users can update their own composers"
ON public.composers
FOR UPDATE
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());
