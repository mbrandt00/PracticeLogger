CREATE VIEW user_unique_piece_sessions_v AS
SELECT DISTINCT ON (user_id, piece_id)
    id,
    start_time,
    end_time,
    piece_id,
    movement_id,
    duration_seconds,
    user_id
FROM practice_sessions
WHERE end_time is not null