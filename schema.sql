--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 16.9 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '@graphql({
    "inflect_names": true,
    "name": "public",
    "max_rows": 1000
})';


--
-- Name: catalogue_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.catalogue_type AS ENUM (
    'op',
    'k',
    'twv',
    'bwv',
    'd',
    'hob',
    'rv',
    's',
    'hwv',
    'h',
    'cnw',
    'woo',
    'do',
    'fp',
    'cd',
    'wab',
    'cff',
    'ms',
    'm',
    'bv',
    'b',
    'sz',
    'jb',
    'lwv',
    'eg',
    'th',
    'wwv',
    'wd',
    'wq',
    'jw',
    'trv',
    'mwv'
);


--
-- Name: key_signature_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_signature_type AS ENUM (
    'c',
    'csharp',
    'cflat',
    'd',
    'dsharp',
    'dflat',
    'e',
    'esharp',
    'eflat',
    'f',
    'fsharp',
    'fflat',
    'g',
    'gsharp',
    'gflat',
    'a',
    'asharp',
    'aflat',
    'b',
    'bsharp',
    'bflat',
    'cminor',
    'csharpminor',
    'cflatminor',
    'dminor',
    'dsharpminor',
    'dflatminor',
    'eminor',
    'esharpminor',
    'eflatminor',
    'fminor',
    'fsharpminor',
    'fflatminor',
    'gminor',
    'gsharpminor',
    'gflatminor',
    'aminor',
    'asharpminor',
    'aflatminor',
    'bminor',
    'bsharpminor',
    'bflatminor'
);


--
-- Name: piece_format; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.piece_format AS ENUM (
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


--
-- Name: before_insert_practice_session(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.before_insert_practice_session() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if there is an existing row with end_time IS NULL for the same user_id
    IF EXISTS (SELECT 1 FROM practice_sessions WHERE end_time IS NULL AND user_id = NEW.user_id) THEN
        -- Update the existing row's end_time to the current time, cast to timestamp without time zone
        UPDATE practice_sessions
        SET end_time = CURRENT_TIMESTAMP::timestamp(0)
        WHERE end_time IS NULL AND user_id = NEW.user_id;
    END IF;

    -- Return the new row to be inserted
    RETURN NEW;
END;
$$;


--
-- Name: before_update_practice_session(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.before_update_practice_session() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Ensure that there is at most one row with end_time IS NULL per user
    IF NEW.end_time IS NULL AND EXISTS (SELECT 1 FROM practice_sessions WHERE end_time IS NULL AND user_id = NEW.user_id AND id != NEW.id) THEN
        RAISE EXCEPTION 'Each user can have at most one practice session with end_time IS NULL.';
    END IF;

    -- Return the new row to be updated
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: pieces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pieces (
    id bigint NOT NULL,
    work_name character varying(255) NOT NULL,
    composer_id bigint,
    nickname text,
    user_id uuid DEFAULT auth.uid(),
    format public.piece_format,
    key_signature public.key_signature_type,
    catalogue_type public.catalogue_type,
    catalogue_number integer,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    searchable_text text,
    catalogue_type_num_desc text,
    catalogue_number_secondary integer,
    composition_year integer,
    composition_year_desc text,
    piece_style text,
    wikipedia_url text,
    instrumentation text[],
    composition_year_string text,
    sub_piece_type text,
    sub_piece_count integer,
    imslp_url text,
    imslp_piece_id bigint,
    total_practice_time integer,
    last_practiced timestamp with time zone,
    collection_id bigint
);


--
-- Name: TABLE pieces; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pieces IS '@graphql({
    "primary_key_columns": ["id"],
    "name": "Piece"
})';


--
-- Name: find_duplicate_piece(integer, public.catalogue_type, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_duplicate_piece(catalogue_number integer, catalogue_type public.catalogue_type, user_id uuid, composer_name text) RETURNS public.pieces
    LANGUAGE plpgsql
    AS $_$
DECLARE
    matching_piece pieces;
    found_composer_id INT;
BEGIN
    -- Find or create the composer record
    SELECT id INTO found_composer_id FROM find_or_create_composer(composer_name);

    -- Find the matching piece
    SELECT *
    INTO matching_piece
    FROM pieces
    WHERE pieces.catalogue_number = $1
        AND pieces.catalogue_type = $2
        AND pieces.user_id = $3
        AND pieces.composer_id = found_composer_id
    LIMIT 1;

    RETURN matching_piece;
END;
$_$;


--
-- Name: composers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.composers (
    id bigint NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    nationality text,
    musical_era text,
    user_id uuid,
    searchable_text text,
    searchable boolean DEFAULT false NOT NULL
);


--
-- Name: find_or_create_composer(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_or_create_composer(name text) RETURNS public.composers
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    composer_record composers;
BEGIN
    -- Check if composer already exists
    SELECT * INTO composer_record FROM composers
    WHERE composers.name = find_or_create_composer.name;

    -- If composer does not exist, create a new one
    IF NOT FOUND THEN
        INSERT INTO composers (name)
        VALUES (find_or_create_composer.name)
        RETURNING * INTO composer_record;
    END IF;

    -- Return the composer record
    RETURN composer_record;
END;
$$;


--
-- Name: find_or_create_composer(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_or_create_composer(first_name text, last_name text) RETURNS public.composers
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
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
$$;


--
-- Name: get_piece_searchable_text(bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_piece_searchable_text(piece_id bigint) RETURNS text
    LANGUAGE sql SECURITY DEFINER
    AS $_$
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
$_$;


--
-- Name: parse_piece_format(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.parse_piece_format(work_name text) RETURNS public.piece_format
    LANGUAGE plpgsql
    AS $$
DECLARE piece_format_value piece_format;
piece_formats piece_format [];
BEGIN piece_formats := ENUM_RANGE(NULL::piece_format);
FOREACH piece_format_value IN ARRAY piece_formats LOOP IF work_name ILIKE '%' || piece_format_value || '%' THEN RETURN piece_format_value;
END IF;
END LOOP;
RETURN NULL;
END;
$$;


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collections (
    id bigint DEFAULT nextval('public.collections_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    url text,
    composer_id bigint NOT NULL,
    searchable_text text,
    searchable boolean DEFAULT false NOT NULL
);


--
-- Name: pieces(public.collections); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.pieces(collection public.collections) RETURNS SETOF public.pieces
    LANGUAGE sql STABLE
    AS $$
    SELECT DISTINCT ON (COALESCE(user_piece.imslp_url, default_piece.imslp_url))
        COALESCE(user_piece, default_piece) AS piece
    FROM 
        public.pieces default_piece
    LEFT JOIN 
        public.pieces user_piece 
        ON user_piece.imslp_url = default_piece.imslp_url
        AND user_piece.collection_id = default_piece.collection_id
        AND user_piece.user_id = auth.uid()
    WHERE 
        default_piece.collection_id = "collection".id
    ORDER BY COALESCE(user_piece.imslp_url, default_piece.imslp_url), user_piece.id DESC NULLS LAST;
$$;


--
-- Name: FUNCTION pieces(collection public.collections); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.pieces(collection public.collections) IS '@graphql({
    "name": "pieces",
    "description": "Returns pieces belonging to this collection, prioritizing user-customized pieces over default pieces with the same IMSLP URL",
    "totalCount": {"enabled": true}
  })';


--
-- Name: refresh_all_searchable_text(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.refresh_all_searchable_text() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE pieces 
    SET searchable_text = get_piece_searchable_text(id);
END;
$$;


--
-- Name: search_collections(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_collections(query text) RETURNS SETOF public.collections
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
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
$$;


--
-- Name: search_composers(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_composers(query text) RETURNS SETOF public.composers
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
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
$$;


--
-- Name: search_pieces(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_pieces(query text) RETURNS SETOF public.pieces
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    WITH terms AS (
        SELECT unnest(string_to_array(lower(unaccent(query)), ' ')) as term
    )
    SELECT p.*
    FROM pieces p
    WHERE searchable_text IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM terms
        WHERE lower(p.searchable_text) NOT LIKE '%' || term || '%'
    )
    ORDER BY similarity(p.searchable_text, unaccent(query)) DESC
    LIMIT 25
$$;


--
-- Name: search_user_pieces(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.search_user_pieces(query text) RETURNS SETOF public.pieces
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
    WITH terms AS (
        SELECT unnest(string_to_array(lower(unaccent(REPLACE(query, '''', ''))), ' ')) as term
    )
    SELECT p.*
    FROM pieces p
    WHERE searchable_text IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM terms
        WHERE lower(p.searchable_text) NOT LIKE '%' || term || '%'
    )
    AND p.user_id = auth.uid()
    ORDER BY similarity(p.searchable_text, unaccent(REPLACE(query, '''', ''))) DESC
    LIMIT 25
$$;


--
-- Name: update_collections_searchable_text(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_collections_searchable_text() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    composer_name TEXT;
BEGIN
  SELECT CONCAT(first_name, ' ', last_name) INTO composer_name
  FROM composers
  WHERE id = NEW.composer_id;

  NEW.searchable_text := CONCAT(NEW.name, ' ', COALESCE(composer_name, ''));

  RETURN NEW;
END;
$$;


--
-- Name: update_composers_searchable_text(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_composers_searchable_text() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.searchable_text := unaccent(CONCAT(NEW.first_name, ' ', NEW.last_name, ' ', NEW.nationality));
  RETURN NEW;
END;
$$;


--
-- Name: update_movement_piece_searchable_text(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_movement_piece_searchable_text() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    current_text TEXT;
    new_text TEXT;
BEGIN
    -- Get the current and new searchable text
    SELECT searchable_text INTO current_text 
    FROM pieces 
    WHERE id = CASE 
        WHEN TG_OP = 'DELETE' THEN OLD.piece_id 
        ELSE NEW.piece_id 
    END;
    
    SELECT get_piece_searchable_text(
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.piece_id 
            ELSE NEW.piece_id 
        END
    ) INTO new_text;
    
    -- Only update if the text would actually change
    IF new_text IS DISTINCT FROM current_text THEN
        UPDATE pieces
        SET searchable_text = new_text
        WHERE id = CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.piece_id 
            ELSE NEW.piece_id 
        END;
    END IF;
    
    RETURN NULL;
END;
$$;


--
-- Name: update_piece_searchable_text(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_piece_searchable_text() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    new_text TEXT;
BEGIN
    -- Get the new searchable text
    SELECT get_piece_searchable_text(NEW.id) INTO new_text;
    
    -- Only update if the text would actually change
    IF new_text IS DISTINCT FROM NEW.searchable_text THEN
        UPDATE pieces 
        SET searchable_text = new_text
        WHERE id = NEW.id;
    END IF;
    
    RETURN NULL;
END;
$$;


--
-- Name: update_practice_stats(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_practice_stats() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public.pieces
    SET 
        total_practice_time = (
            SELECT COALESCE(SUM(duration_seconds), 0) 
            FROM public.practice_sessions 
            WHERE piece_id = pieces.id AND deleted_at IS NULL
        ),
        last_practiced = (
            SELECT GREATEST(
                COALESCE((
                    SELECT GREATEST(
                        MAX(end_time),
                        MAX(start_time)
                    ) 
                    FROM public.practice_sessions 
                    WHERE piece_id = pieces.id AND deleted_at IS NULL
                ), NULL),
                COALESCE((
                    SELECT GREATEST(
                        MAX(end_time),
                        MAX(start_time)
                    ) 
                    FROM public.practice_sessions 
                    WHERE movement_id IN (
                        SELECT id FROM public.movements WHERE piece_id = pieces.id
                    ) AND deleted_at IS NULL
                ), NULL)
            )
        )
    WHERE id IN (
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.piece_id 
            ELSE NEW.piece_id 
        END
    );

    -- Update movements stats
    UPDATE public.movements
    SET 
        total_practice_time = (
            SELECT COALESCE(SUM(duration_seconds), 0) 
            FROM public.practice_sessions 
            WHERE movement_id = movements.id AND deleted_at IS NULL
        ),
        last_practiced = (
            SELECT GREATEST(
                MAX(end_time),
                MAX(start_time)
            )
            FROM public.practice_sessions 
            WHERE movement_id = movements.id AND deleted_at IS NULL
        )
    WHERE id IN (
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.movement_id 
            ELSE NEW.movement_id 
        END
    );

    RETURN NULL;
END;
$$;


--
-- Name: composers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.composers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: composers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.composers_id_seq OWNED BY public.composers.id;


--
-- Name: movements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.movements (
    id bigint NOT NULL,
    piece_id bigint NOT NULL,
    name character varying(255),
    number integer,
    key_signature public.key_signature_type,
    nickname text,
    download_url text,
    total_practice_time integer,
    last_practiced timestamp with time zone
);


--
-- Name: TABLE movements; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.movements IS '@graphql({
    "primary_key_columns": ["id"],
    "name": "Movement"
})';


--
-- Name: movements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.movements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.movements_id_seq OWNED BY public.movements.id;


--
-- Name: pieces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pieces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pieces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pieces_id_seq OWNED BY public.pieces.id;


--
-- Name: practice_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.practice_sessions (
    id bigint NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    piece_id bigint NOT NULL,
    movement_id bigint,
    user_id uuid DEFAULT auth.uid() NOT NULL,
    duration_seconds integer GENERATED ALWAYS AS (
CASE
    WHEN (end_time IS NOT NULL) THEN (EXTRACT(epoch FROM (end_time - start_time)))::integer
    ELSE NULL::integer
END) STORED,
    deleted_at timestamp without time zone
);


--
-- Name: practice_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.practice_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: practice_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.practice_sessions_id_seq OWNED BY public.practice_sessions.id;


--
-- Name: composers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composers ALTER COLUMN id SET DEFAULT nextval('public.composers_id_seq'::regclass);


--
-- Name: movements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movements ALTER COLUMN id SET DEFAULT nextval('public.movements_id_seq'::regclass);


--
-- Name: pieces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pieces ALTER COLUMN id SET DEFAULT nextval('public.pieces_id_seq'::regclass);


--
-- Name: practice_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.practice_sessions ALTER COLUMN id SET DEFAULT nextval('public.practice_sessions_id_seq'::regclass);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: composers composers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composers
    ADD CONSTRAINT composers_pkey PRIMARY KEY (id);


--
-- Name: movements movements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movements
    ADD CONSTRAINT movements_pkey PRIMARY KEY (id);


--
-- Name: pieces pieces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pieces
    ADD CONSTRAINT pieces_pkey PRIMARY KEY (id);


--
-- Name: practice_sessions practice_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.practice_sessions
    ADD CONSTRAINT practice_sessions_pkey PRIMARY KEY (id);


--
-- Name: idx_collections_composer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_collections_composer_id ON public.collections USING btree (composer_id);


--
-- Name: idx_fk_collection; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fk_collection ON public.pieces USING btree (collection_id);


--
-- Name: index_collections_on_name_and_composer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collections_on_name_and_composer_id ON public.collections USING btree (name, composer_id);


--
-- Name: index_pieces_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pieces_on_collection_id ON public.pieces USING btree (imslp_url, user_id);


--
-- Name: index_pieces_on_imslp_url_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pieces_on_imslp_url_and_user_id ON public.pieces USING btree (imslp_url, user_id);


--
-- Name: index_practice_sessions_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_practice_sessions_on_deleted_at ON public.practice_sessions USING btree (deleted_at);


--
-- Name: movements_piece_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX movements_piece_id_idx ON public.movements USING btree (piece_id);


--
-- Name: pieces_composer_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pieces_composer_id_idx ON public.pieces USING btree (composer_id);


--
-- Name: pieces_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pieces_user_id_idx ON public.pieces USING btree (user_id);


--
-- Name: practice_sessions_movement_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX practice_sessions_movement_id_idx ON public.practice_sessions USING btree (movement_id);


--
-- Name: practice_sessions_piece_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX practice_sessions_piece_id_idx ON public.practice_sessions USING btree (piece_id);


--
-- Name: practice_sessions_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX practice_sessions_user_id_idx ON public.practice_sessions USING btree (user_id);


--
-- Name: collections before_insert_or_update_on_collections_set_searchable_text; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER before_insert_or_update_on_collections_set_searchable_text BEFORE INSERT OR UPDATE ON public.collections FOR EACH ROW EXECUTE FUNCTION public.update_collections_searchable_text();


--
-- Name: composers before_insert_or_update_on_composers_set_searchable_text; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER before_insert_or_update_on_composers_set_searchable_text BEFORE INSERT OR UPDATE ON public.composers FOR EACH ROW EXECUTE FUNCTION public.update_composers_searchable_text();


--
-- Name: practice_sessions before_insert_practice_session_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER before_insert_practice_session_trigger BEFORE INSERT ON public.practice_sessions FOR EACH ROW EXECUTE FUNCTION public.before_insert_practice_session();


--
-- Name: practice_sessions before_update_practice_session_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER before_update_practice_session_trigger BEFORE UPDATE ON public.practice_sessions FOR EACH ROW EXECUTE FUNCTION public.before_update_practice_session();


--
-- Name: pieces handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.pieces FOR EACH ROW EXECUTE FUNCTION public.moddatetime('updated_at');


--
-- Name: movements movement_update_piece_searchable_text; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER movement_update_piece_searchable_text AFTER INSERT OR DELETE OR UPDATE ON public.movements FOR EACH ROW EXECUTE FUNCTION public.update_movement_piece_searchable_text();


--
-- Name: pieces piece_searchable_text_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER piece_searchable_text_update AFTER INSERT OR UPDATE ON public.pieces FOR EACH ROW EXECUTE FUNCTION public.update_piece_searchable_text();


--
-- Name: practice_sessions practice_sessions_stats_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER practice_sessions_stats_trigger AFTER INSERT OR DELETE OR UPDATE ON public.practice_sessions FOR EACH ROW EXECUTE FUNCTION public.update_practice_stats();


--
-- Name: collections collections_composer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_composer_id_fkey FOREIGN KEY (composer_id) REFERENCES public.composers(id);


--
-- Name: composers composers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composers
    ADD CONSTRAINT composers_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: pieces fk_collection; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pieces
    ADD CONSTRAINT fk_collection FOREIGN KEY (collection_id) REFERENCES public.collections(id);


--
-- Name: CONSTRAINT fk_collection ON pieces; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT fk_collection ON public.pieces IS '@graphql({"foreign_name": "collection", "local_name": "pieces"})';


--
-- Name: movements movements_piece_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movements
    ADD CONSTRAINT movements_piece_id_fkey FOREIGN KEY (piece_id) REFERENCES public.pieces(id) ON DELETE CASCADE;


--
-- Name: pieces pieces_composer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pieces
    ADD CONSTRAINT pieces_composer_id_fkey FOREIGN KEY (composer_id) REFERENCES public.composers(id);


--
-- Name: pieces pieces_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pieces
    ADD CONSTRAINT pieces_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: practice_sessions practice_sessions_movement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.practice_sessions
    ADD CONSTRAINT practice_sessions_movement_id_fkey FOREIGN KEY (movement_id) REFERENCES public.movements(id);


--
-- Name: practice_sessions practice_sessions_piece_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.practice_sessions
    ADD CONSTRAINT practice_sessions_piece_id_fkey FOREIGN KEY (piece_id) REFERENCES public.pieces(id) ON DELETE CASCADE;


--
-- Name: practice_sessions practice_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.practice_sessions
    ADD CONSTRAINT practice_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: movements Allow updates from trigger; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow updates from trigger" ON public.movements FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: pieces Allow updates from trigger; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow updates from trigger" ON public.pieces FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: composers Users can update their own composers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update their own composers" ON public.composers FOR UPDATE USING ((user_id = auth.uid())) WITH CHECK ((user_id = auth.uid()));


--
-- Name: pieces auth_delete_pieces; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_delete_pieces ON public.pieces FOR DELETE TO authenticated USING ((user_id = auth.uid()));


--
-- Name: practice_sessions auth_delete_practice_sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_delete_practice_sessions ON public.practice_sessions FOR DELETE TO authenticated USING ((user_id = auth.uid()));


--
-- Name: composers auth_insert_composers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_insert_composers ON public.composers FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: movements auth_insert_movements; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_insert_movements ON public.movements FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: pieces auth_insert_pieces; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_insert_pieces ON public.pieces FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: practice_sessions auth_insert_practice_sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_insert_practice_sessions ON public.practice_sessions FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: collections auth_read_collections; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_read_collections ON public.collections FOR SELECT TO authenticated USING (true);


--
-- Name: composers auth_read_composers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_read_composers ON public.composers FOR SELECT TO authenticated USING (true);


--
-- Name: movements auth_read_movements; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_read_movements ON public.movements FOR SELECT TO authenticated USING (true);


--
-- Name: pieces auth_read_pieces; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_read_pieces ON public.pieces FOR SELECT TO authenticated USING (true);


--
-- Name: practice_sessions auth_read_practice_sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_read_practice_sessions ON public.practice_sessions FOR SELECT TO authenticated USING (true);


--
-- Name: practice_sessions auth_update_practice_sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY auth_update_practice_sessions ON public.practice_sessions FOR UPDATE TO authenticated USING ((user_id = auth.uid()));


--
-- Name: collections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.collections ENABLE ROW LEVEL SECURITY;

--
-- Name: composers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.composers ENABLE ROW LEVEL SECURITY;

--
-- Name: movements; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.movements ENABLE ROW LEVEL SECURITY;

--
-- Name: pieces; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.pieces ENABLE ROW LEVEL SECURITY;

--
-- Name: practice_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.practice_sessions ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--

