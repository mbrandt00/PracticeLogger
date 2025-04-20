


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


CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS '@graphql({
    "inflect_names": true,
    "name": "public"
})';



CREATE EXTENSION IF NOT EXISTS "moddatetime" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pg_trgm" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "unaccent" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."catalogue_type" AS ENUM (
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


ALTER TYPE "public"."catalogue_type" OWNER TO "postgres";


CREATE TYPE "public"."key_signature_type" AS ENUM (
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


ALTER TYPE "public"."key_signature_type" OWNER TO "postgres";


CREATE TYPE "public"."piece_format" AS ENUM (
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


ALTER TYPE "public"."piece_format" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."before_insert_practice_session"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
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


ALTER FUNCTION "public"."before_insert_practice_session"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."before_update_practice_session"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
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


ALTER FUNCTION "public"."before_update_practice_session"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."pieces" (
    "id" bigint NOT NULL,
    "work_name" character varying(255) NOT NULL,
    "composer_id" bigint,
    "nickname" "text",
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "format" "public"."piece_format",
    "key_signature" "public"."key_signature_type",
    "catalogue_type" "public"."catalogue_type",
    "catalogue_number" integer,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "searchable_text" "text",
    "catalogue_type_num_desc" "text",
    "catalogue_number_secondary" integer,
    "composition_year" integer,
    "composition_year_desc" "text",
    "piece_style" "text",
    "wikipedia_url" "text",
    "instrumentation" "text"[],
    "composition_year_string" "text",
    "sub_piece_type" "text",
    "sub_piece_count" integer,
    "imslp_url" "text",
    "imslp_piece_id" bigint,
    "total_practice_time" integer,
    "last_practiced" timestamp with time zone,
    "collection_id" bigint
);


ALTER TABLE "public"."pieces" OWNER TO "postgres";


COMMENT ON TABLE "public"."pieces" IS '@graphql({
    "primary_key_columns": ["id"],
    "name": "Piece"
})';



CREATE OR REPLACE FUNCTION "public"."find_duplicate_piece"("catalogue_number" integer, "catalogue_type" "public"."catalogue_type", "user_id" "uuid", "composer_name" "text") RETURNS "public"."pieces"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."find_duplicate_piece"("catalogue_number" integer, "catalogue_type" "public"."catalogue_type", "user_id" "uuid", "composer_name" "text") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."composers" (
    "id" bigint NOT NULL,
    "name" character varying(255) NOT NULL
);


ALTER TABLE "public"."composers" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."find_or_create_composer"("name" "text") RETURNS "public"."composers"
    LANGUAGE "plpgsql" SECURITY DEFINER
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


ALTER FUNCTION "public"."find_or_create_composer"("name" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_piece_searchable_text"("piece_id" bigint) RETURNS "text"
    LANGUAGE "sql" SECURITY DEFINER
    AS $_$
    SELECT 
        CONCAT_WS(' ',
            unaccent(REPLACE(COALESCE(p.work_name, ''), '''', '')),
            unaccent(REPLACE(COALESCE(p.nickname, ''), '''', '')),
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
            unaccent(REPLACE(COALESCE(c.name, ''), '''', '')),
            (SELECT COALESCE(string_agg(
                CONCAT_WS(' ', 
                    unaccent(REPLACE(COALESCE(name, ''), '''', '')), 
                    unaccent(REPLACE(COALESCE(nickname, ''), '''', ''))
                ), ' '), '')
             FROM movements 
             WHERE piece_id = $1)
        )
    FROM pieces p
    LEFT JOIN composers c ON c.id = p.composer_id
    WHERE p.id = piece_id;
$_$;


ALTER FUNCTION "public"."get_piece_searchable_text"("piece_id" bigint) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."parse_piece_format"("work_name" "text") RETURNS "public"."piece_format"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."parse_piece_format"("work_name" "text") OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."collections_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."collections_id_seq" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."collections" (
    "id" bigint DEFAULT "nextval"('"public"."collections_id_seq"'::"regclass") NOT NULL,
    "name" "text" NOT NULL,
    "url" "text",
    "composer_id" bigint NOT NULL
);


ALTER TABLE "public"."collections" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."pieces"("collection" "public"."collections") RETURNS SETOF "public"."pieces"
    LANGUAGE "sql" STABLE
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


ALTER FUNCTION "public"."pieces"("collection" "public"."collections") OWNER TO "postgres";


COMMENT ON FUNCTION "public"."pieces"("collection" "public"."collections") IS '@graphql({
    "name": "pieces",
    "description": "Returns pieces belonging to this collection, prioritizing user-customized pieces over default pieces with the same IMSLP URL",
    "totalCount": {"enabled": true}
  })';



CREATE OR REPLACE FUNCTION "public"."search_pieces"("query" "text") RETURNS SETOF "public"."pieces"
    LANGUAGE "sql" STABLE SECURITY DEFINER
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


ALTER FUNCTION "public"."search_pieces"("query" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."search_user_pieces"("query" "text") RETURNS SETOF "public"."pieces"
    LANGUAGE "sql" STABLE SECURITY DEFINER
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


ALTER FUNCTION "public"."search_user_pieces"("query" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_movement_piece_searchable_text"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
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


ALTER FUNCTION "public"."update_movement_piece_searchable_text"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_piece_searchable_text"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
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


ALTER FUNCTION "public"."update_piece_searchable_text"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_practice_stats"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Update pieces stats
    UPDATE public.pieces
    SET 
        total_practice_time = (
            SELECT COALESCE(SUM(duration_seconds), 0) 
            FROM public.practice_sessions 
            WHERE piece_id = pieces.id
        ),
        last_practiced = (
            SELECT GREATEST(
                COALESCE((
                    SELECT GREATEST(
                        MAX(end_time),
                        MAX(start_time)
                    ) 
                    FROM public.practice_sessions 
                    WHERE piece_id = pieces.id
                ), NULL),
                COALESCE((
                    SELECT GREATEST(
                        MAX(end_time),
                        MAX(start_time)
                    ) 
                    FROM public.practice_sessions 
                    WHERE movement_id IN (SELECT id FROM public.movements WHERE piece_id = pieces.id)
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
            WHERE movement_id = movements.id
        ),
        last_practiced = (
            SELECT GREATEST(
                MAX(end_time),
                MAX(start_time)
            )
            FROM public.practice_sessions 
            WHERE movement_id = movements.id
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


ALTER FUNCTION "public"."update_practice_stats"() OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."composers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."composers_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."composers_id_seq" OWNED BY "public"."composers"."id";



CREATE TABLE IF NOT EXISTS "public"."movements" (
    "id" bigint NOT NULL,
    "piece_id" bigint NOT NULL,
    "name" character varying(255),
    "number" integer,
    "key_signature" "public"."key_signature_type",
    "nickname" "text",
    "download_url" "text",
    "total_practice_time" integer,
    "last_practiced" timestamp with time zone
);


ALTER TABLE "public"."movements" OWNER TO "postgres";


COMMENT ON TABLE "public"."movements" IS '@graphql({
    "primary_key_columns": ["id"],
    "name": "Movement"
})';



CREATE SEQUENCE IF NOT EXISTS "public"."movements_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."movements_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."movements_id_seq" OWNED BY "public"."movements"."id";



CREATE SEQUENCE IF NOT EXISTS "public"."pieces_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."pieces_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."pieces_id_seq" OWNED BY "public"."pieces"."id";



CREATE TABLE IF NOT EXISTS "public"."practice_sessions" (
    "id" bigint NOT NULL,
    "start_time" timestamp without time zone NOT NULL,
    "end_time" timestamp without time zone,
    "piece_id" bigint NOT NULL,
    "movement_id" bigint,
    "user_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "duration_seconds" integer GENERATED ALWAYS AS (
CASE
    WHEN ("end_time" IS NOT NULL) THEN (EXTRACT(epoch FROM ("end_time" - "start_time")))::integer
    ELSE NULL::integer
END) STORED
);


ALTER TABLE "public"."practice_sessions" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."practice_sessions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."practice_sessions_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."practice_sessions_id_seq" OWNED BY "public"."practice_sessions"."id";



ALTER TABLE ONLY "public"."composers" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."composers_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."movements" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."movements_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."pieces" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."pieces_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."practice_sessions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."practice_sessions_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."collections"
    ADD CONSTRAINT "collections_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."composers"
    ADD CONSTRAINT "composers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."movements"
    ADD CONSTRAINT "movements_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pieces"
    ADD CONSTRAINT "pieces_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."practice_sessions"
    ADD CONSTRAINT "practice_sessions_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_pieces_searchable_text_trgm" ON "public"."pieces" USING "gin" ("searchable_text" "public"."gin_trgm_ops");



CREATE OR REPLACE TRIGGER "before_insert_practice_session_trigger" BEFORE INSERT ON "public"."practice_sessions" FOR EACH ROW EXECUTE FUNCTION "public"."before_insert_practice_session"();



CREATE OR REPLACE TRIGGER "before_update_practice_session_trigger" BEFORE UPDATE ON "public"."practice_sessions" FOR EACH ROW EXECUTE FUNCTION "public"."before_update_practice_session"();



CREATE OR REPLACE TRIGGER "handle_updated_at" BEFORE UPDATE ON "public"."pieces" FOR EACH ROW EXECUTE FUNCTION "public"."moddatetime"('updated_at');



CREATE OR REPLACE TRIGGER "movement_update_piece_searchable_text" AFTER INSERT OR DELETE OR UPDATE ON "public"."movements" FOR EACH ROW EXECUTE FUNCTION "public"."update_movement_piece_searchable_text"();



CREATE OR REPLACE TRIGGER "piece_searchable_text_update" AFTER INSERT OR UPDATE ON "public"."pieces" FOR EACH ROW EXECUTE FUNCTION "public"."update_piece_searchable_text"();



CREATE OR REPLACE TRIGGER "practice_sessions_stats_trigger" AFTER INSERT OR DELETE OR UPDATE ON "public"."practice_sessions" FOR EACH ROW EXECUTE FUNCTION "public"."update_practice_stats"();



ALTER TABLE ONLY "public"."collections"
    ADD CONSTRAINT "collections_composer_id_fkey" FOREIGN KEY ("composer_id") REFERENCES "public"."composers"("id");



ALTER TABLE ONLY "public"."pieces"
    ADD CONSTRAINT "fk_collection" FOREIGN KEY ("collection_id") REFERENCES "public"."collections"("id");



COMMENT ON CONSTRAINT "fk_collection" ON "public"."pieces" IS '@graphql({"foreign_name": "collection", "local_name": "pieces"})';



ALTER TABLE ONLY "public"."movements"
    ADD CONSTRAINT "movements_piece_id_fkey" FOREIGN KEY ("piece_id") REFERENCES "public"."pieces"("id");



ALTER TABLE ONLY "public"."pieces"
    ADD CONSTRAINT "pieces_composer_id_fkey" FOREIGN KEY ("composer_id") REFERENCES "public"."composers"("id");



ALTER TABLE ONLY "public"."pieces"
    ADD CONSTRAINT "pieces_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."practice_sessions"
    ADD CONSTRAINT "practice_sessions_movement_id_fkey" FOREIGN KEY ("movement_id") REFERENCES "public"."movements"("id");



ALTER TABLE ONLY "public"."practice_sessions"
    ADD CONSTRAINT "practice_sessions_piece_id_fkey" FOREIGN KEY ("piece_id") REFERENCES "public"."pieces"("id");



ALTER TABLE ONLY "public"."practice_sessions"
    ADD CONSTRAINT "practice_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");



CREATE POLICY "Allow updates from trigger" ON "public"."movements" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Allow updates from trigger" ON "public"."pieces" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "auth_delete_practice_sessions" ON "public"."practice_sessions" FOR DELETE TO "authenticated" USING (("user_id" = "auth"."uid"()));



CREATE POLICY "auth_insert_composers" ON "public"."composers" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "auth_insert_movements" ON "public"."movements" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "auth_insert_pieces" ON "public"."pieces" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "auth_insert_practice_sessions" ON "public"."practice_sessions" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "auth_read_collections" ON "public"."collections" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "auth_read_collections" ON "public"."practice_sessions" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "auth_read_composers" ON "public"."composers" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "auth_read_movements" ON "public"."movements" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "auth_read_pieces" ON "public"."pieces" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "auth_read_practice_sessions" ON "public"."practice_sessions" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "auth_update_practice_sessions" ON "public"."practice_sessions" FOR UPDATE TO "authenticated" USING (("user_id" = "auth"."uid"()));



ALTER TABLE "public"."collections" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."composers" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."movements" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pieces" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."practice_sessions" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."practice_sessions";



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."before_insert_practice_session"() TO "anon";
GRANT ALL ON FUNCTION "public"."before_insert_practice_session"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."before_insert_practice_session"() TO "service_role";



GRANT ALL ON FUNCTION "public"."before_update_practice_session"() TO "anon";
GRANT ALL ON FUNCTION "public"."before_update_practice_session"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."before_update_practice_session"() TO "service_role";



GRANT ALL ON TABLE "public"."pieces" TO "anon";
GRANT ALL ON TABLE "public"."pieces" TO "authenticated";
GRANT ALL ON TABLE "public"."pieces" TO "service_role";



GRANT ALL ON FUNCTION "public"."find_duplicate_piece"("catalogue_number" integer, "catalogue_type" "public"."catalogue_type", "user_id" "uuid", "composer_name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."find_duplicate_piece"("catalogue_number" integer, "catalogue_type" "public"."catalogue_type", "user_id" "uuid", "composer_name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."find_duplicate_piece"("catalogue_number" integer, "catalogue_type" "public"."catalogue_type", "user_id" "uuid", "composer_name" "text") TO "service_role";



GRANT ALL ON TABLE "public"."composers" TO "anon";
GRANT ALL ON TABLE "public"."composers" TO "authenticated";
GRANT ALL ON TABLE "public"."composers" TO "service_role";



GRANT ALL ON FUNCTION "public"."find_or_create_composer"("name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."find_or_create_composer"("name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."find_or_create_composer"("name" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_piece_searchable_text"("piece_id" bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."get_piece_searchable_text"("piece_id" bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_piece_searchable_text"("piece_id" bigint) TO "service_role";



GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."moddatetime"() TO "postgres";
GRANT ALL ON FUNCTION "public"."moddatetime"() TO "anon";
GRANT ALL ON FUNCTION "public"."moddatetime"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."moddatetime"() TO "service_role";



GRANT ALL ON FUNCTION "public"."parse_piece_format"("work_name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."parse_piece_format"("work_name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."parse_piece_format"("work_name" "text") TO "service_role";



GRANT ALL ON SEQUENCE "public"."collections_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."collections_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."collections_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."collections" TO "anon";
GRANT ALL ON TABLE "public"."collections" TO "authenticated";
GRANT ALL ON TABLE "public"."collections" TO "service_role";



GRANT ALL ON FUNCTION "public"."pieces"("collection" "public"."collections") TO "anon";
GRANT ALL ON FUNCTION "public"."pieces"("collection" "public"."collections") TO "authenticated";
GRANT ALL ON FUNCTION "public"."pieces"("collection" "public"."collections") TO "service_role";



GRANT ALL ON FUNCTION "public"."search_pieces"("query" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."search_pieces"("query" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."search_pieces"("query" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."search_user_pieces"("query" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."search_user_pieces"("query" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."search_user_pieces"("query" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "postgres";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "anon";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "service_role";



GRANT ALL ON FUNCTION "public"."show_limit"() TO "postgres";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "anon";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "service_role";



GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "postgres";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "anon";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "service_role";



GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."unaccent"("text") TO "postgres";
GRANT ALL ON FUNCTION "public"."unaccent"("text") TO "anon";
GRANT ALL ON FUNCTION "public"."unaccent"("text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."unaccent"("text") TO "service_role";



GRANT ALL ON FUNCTION "public"."unaccent"("regdictionary", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."unaccent"("regdictionary", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."unaccent"("regdictionary", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."unaccent"("regdictionary", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."unaccent_init"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."unaccent_init"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."unaccent_init"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."unaccent_init"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."unaccent_lexize"("internal", "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."unaccent_lexize"("internal", "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."unaccent_lexize"("internal", "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."unaccent_lexize"("internal", "internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_movement_piece_searchable_text"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_movement_piece_searchable_text"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_movement_piece_searchable_text"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_piece_searchable_text"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_piece_searchable_text"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_piece_searchable_text"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_practice_stats"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_practice_stats"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_practice_stats"() TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "service_role";


















GRANT ALL ON SEQUENCE "public"."composers_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."composers_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."composers_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."movements" TO "anon";
GRANT ALL ON TABLE "public"."movements" TO "authenticated";
GRANT ALL ON TABLE "public"."movements" TO "service_role";



GRANT ALL ON SEQUENCE "public"."movements_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."movements_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."movements_id_seq" TO "service_role";



GRANT ALL ON SEQUENCE "public"."pieces_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."pieces_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."pieces_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."practice_sessions" TO "anon";
GRANT ALL ON TABLE "public"."practice_sessions" TO "authenticated";
GRANT ALL ON TABLE "public"."practice_sessions" TO "service_role";



GRANT ALL ON SEQUENCE "public"."practice_sessions_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."practice_sessions_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."practice_sessions_id_seq" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
