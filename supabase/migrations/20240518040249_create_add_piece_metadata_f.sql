CREATE TYPE PieceMetadata AS (
    opus_type opus_type,
    opus_number INT,
    piece_format piece_format,
    key_signature_type key_signature_type,
    key_signature_tonality key_signature_tonality

);

CREATE OR REPLACE FUNCTION parse_piece_metadata(work_name TEXT)
RETURNS PieceMetadata AS $$
DECLARE
    opus_info opus_information;
    piece_format_value piece_format;
    key_signature_value key_signature;
    metadata PieceMetadata;
BEGIN
    opus_info := parse_opus_information(work_name);

    piece_format_value := parse_piece_format(work_name);

    key_signature_value := parse_piece_key_signature(work_name);

    metadata.opus_type := opus_info.opus_type;
    metadata.opus_number := opus_info.opus_number;
    metadata.piece_format := piece_format_value;
    metadata.key_signature_type := key_signature_value.key;
    metadata.key_signature_tonality := key_signature_value.tonality;

    RETURN metadata;
END
$$ LANGUAGE plpgsql;