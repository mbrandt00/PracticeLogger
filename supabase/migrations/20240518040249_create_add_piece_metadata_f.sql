CREATE TYPE PieceMetadata AS (
    catalogue_type catalogue_type,
    catalogue_number INT,
    format piece_format,
    key_signature key_signature_type,
    tonality key_signature_tonality

);

CREATE OR REPLACE FUNCTION parse_piece_metadata(work_name TEXT)
RETURNS PieceMetadata AS $$
DECLARE
    opus_info opus_information;
    format piece_format;
    key_signature_value key_signature;
    metadata PieceMetadata;
BEGIN
    opus_info := parse_opus_information(work_name);

    format := parse_piece_format(work_name);

    key_signature_value := parse_piece_key_signature(work_name);

    metadata.catalogue_type := opus_info.catalogue_type;
    metadata.catalogue_number := opus_info.catalogue_number;
    metadata.format := format;
    metadata.key_signature := key_signature_value.key;
    metadata.tonality := key_signature_value.tonality;

    RETURN metadata;
END
$$ LANGUAGE plpgsql;