CREATE TYPE piece_format AS ENUM (
    'bagatelle',
    'ballade',
    'canon',
    'caprice',
    'chorale',
    'concerto',
    'dance',
    'etude',
    'fantasy',
    'fugue',
    'gavotte',
    'gigue',
    'impromptu',
    'intermezzo',
    'lied',
    'march',
    'mazurka',
    'mass',
    'minuet',
    'nocturne',
    'overture',
    'opera',
    'oratorio',
    'pastiche',
    'prelude',
    'polonaise',
    'rhapsody',
    'requiem',
    'rondo',
    'sarabande',
    'scherzo',
    'seranade',
    'sonata',
    'string_quartet',
    'suite',
    'symphony',
    'tarantella',
    'toccata',
    'variations',
    'waltz'
);
CREATE OR REPLACE FUNCTION parse_piece_format(work_name TEXT) RETURNS piece_format AS $$
DECLARE piece_format_value piece_format;
piece_formats piece_format [];
BEGIN piece_formats := ENUM_RANGE(NULL::piece_format);
FOREACH piece_format_value IN ARRAY piece_formats LOOP IF work_name ILIKE '%' || piece_format_value || '%' THEN RETURN piece_format_value;
END IF;
END LOOP;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;
ALTER TABLE pieces
ADD COLUMN format piece_format;