COMMENT ON SCHEMA public IS e'@graphql({
    "inflect_names": true,
    "name": "public"
})';

-- Make imslp schema secondary with a distinct name
COMMENT ON SCHEMA imslp IS e'@graphql({
    "inflect_names": true,
    "name": "imslp_api"
})';


SET search_path = public, imslp;

COMMENT ON TABLE public.pieces IS E'@graphql({
    "primary_key_columns": ["id"],
    "name": "Piece"
})';

COMMENT ON TABLE imslp.pieces IS E'@graphql({
    "primary_key_columns": ["id"],
    "name": "ImslpPiece"
})';

COMMENT ON TABLE public.movements IS E'@graphql({
    "primary_key_columns": ["id"],
    "name": "Movement"
})';

COMMENT ON TABLE imslp.movements IS E'@graphql({
    "primary_key_columns": ["id"],
    "name": "ImslpMovement"
})';
