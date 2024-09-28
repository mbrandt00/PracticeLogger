CREATE TYPE key_signature_type AS ENUM (
    'C',
    'Csharp',
    'Cflat',
    'D',
    'Dsharp',
    'Dflat',
    'E',
    'Esharp',
    'Eflat',
    'F',
    'Fsharp',
    'Fflat',
    'G',
    'Gsharp',
    'Gflat',
    'A',
    'Asharp',
    'Aflat',
    'B',
    'Bsharp',
    'Bflat'
);
CREATE TYPE key_signature_tonality AS ENUM ('Major', 'Minor');
CREATE TYPE key_signature AS (
    key key_signature_type,
    tonality key_signature_tonality
);
CREATE OR REPLACE FUNCTION parse_piece_key_signature(work_name TEXT) RETURNS key_signature AS $$
DECLARE key_info key_signature;
found_key key_signature_type;
BEGIN key_info := ROW(NULL, NULL)::key_signature;
-- Initialize composite type
work_name := LOWER(work_name);
-- Find the key signature
found_key := (
    SELECT CASE
            WHEN work_name LIKE '%c#%'
            OR work_name LIKE '%c sharp%' THEN 'C♯'
            WHEN work_name LIKE '%c-flat%'
            OR work_name LIKE '%c flat%' THEN 'C♭'
            WHEN work_name LIKE '% c %' THEN 'C'
            WHEN work_name LIKE '%d#%'
            OR work_name LIKE '%d sharp%' THEN 'D♯'
            WHEN work_name LIKE '%d-flat%'
            OR work_name LIKE '%d flat%' THEN 'D♭'
            WHEN work_name LIKE '% d %' THEN 'D'
            WHEN work_name LIKE '%e#%'
            OR work_name LIKE '%e sharp%' THEN 'E♯'
            WHEN work_name LIKE '%e-flat%'
            OR work_name LIKE '%e flat%' THEN 'E♭'
            WHEN work_name LIKE '% e %' THEN 'E'
            WHEN work_name LIKE '%f#%'
            OR work_name LIKE '%f sharp%' THEN 'F♯'
            WHEN work_name LIKE '%f-flat%'
            OR work_name LIKE '%f flat%' THEN 'F♭'
            WHEN work_name LIKE '% f %' THEN 'F'
            WHEN work_name LIKE '%g#%'
            OR work_name LIKE '%g sharp%' THEN 'G♯'
            WHEN work_name LIKE '%g-flat%'
            OR work_name LIKE '%g flat%' THEN 'G♭'
            WHEN work_name LIKE '% g %' THEN 'G'
            WHEN work_name LIKE '%a#%'
            OR work_name LIKE '%a sharp%' THEN 'A♯'
            WHEN work_name LIKE '%a-flat%'
            OR work_name LIKE '%a flat%' THEN 'A♭'
            WHEN work_name LIKE '% a %' THEN 'A'
            WHEN work_name LIKE '%b#%'
            OR work_name LIKE '%b sharp%' THEN 'B♯'
            WHEN work_name LIKE '%b-flat%'
            OR work_name LIKE '%b flat%' THEN 'B♭'
            WHEN work_name LIKE '% b %' THEN 'B'
            ELSE NULL
        END
);
-- Set the found key signature
key_info.key := found_key;
-- Determine the tonality
IF work_name LIKE '%minor%' THEN key_info.tonality := 'Minor';
ELSE key_info.tonality := 'Major';
END IF;
RETURN key_info;
END;
$$ LANGUAGE plpgsql;
ALTER TABLE pieces
ADD COLUMN key_signature key_signature_type,
    ADD COLUMN tonality key_signature_tonality;