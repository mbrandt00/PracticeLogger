ALTER TABLE pieces
ADD COLUMN nickname text;


CREATE OR REPLACE FUNCTION parse_piece_nickname(work_name TEXT)
RETURNS TEXT AS $$
DECLARE
    nickname TEXT;
BEGIN
    nickname := substring(work_name FROM '"([^"]*)"' );

    RETURN nickname;
END;
$$ LANGUAGE plpgsql;

DROP TYPE IF EXISTS PieceMetadata CASCADE;

CREATE TYPE PieceMetadata AS (
    catalogue_type catalogue_type,
    catalogue_number INT,
    format piece_format,
    key_signature key_signature_type,
    tonality key_signature_tonality,
    nickname text
);

CREATE OR REPLACE FUNCTION parse_piece_metadata(work_name TEXT)
RETURNS PieceMetadata AS $$
DECLARE
    opus_info opus_information;
    format piece_format;
    key_signature_value key_signature;
    nickname text;
    metadata PieceMetadata;
BEGIN
    opus_info := parse_opus_information(work_name);

    format := parse_piece_format(work_name);

    key_signature_value := parse_piece_key_signature(work_name);

    nickname := parse_piece_nickname(work_name);

    metadata := ROW(
        opus_info.catalogue_type,
        opus_info.catalogue_number,
        format,
        key_signature_value.key,
        key_signature_value.tonality,
        nickname
    )::PieceMetadata;

    RETURN metadata;
END;
$$ LANGUAGE plpgsql;
