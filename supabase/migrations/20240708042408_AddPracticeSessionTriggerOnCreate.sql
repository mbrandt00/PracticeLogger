CREATE OR REPLACE FUNCTION before_insert_practice_session()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if there is an existing row with end_time IS NULL for the same user_id
    IF EXISTS (SELECT 1 FROM practice_sessions WHERE end_time IS NULL AND user_id = NEW.user_id) THEN
        -- Update the existing row's end_time to the current time, cast to timestamp without time zone
        UPDATE practice_sessions
        SET end_time = CURRENT_TIMESTAMP::timestamp without time zone
        WHERE end_time IS NULL AND user_id = NEW.user_id;
    END IF;

    -- Return the new row to be inserted
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION before_update_practice_session()
RETURNS TRIGGER AS $$
BEGIN
    -- Ensure that there is at most one row with end_time IS NULL per user
    IF NEW.end_time IS NULL AND EXISTS (SELECT 1 FROM practice_sessions WHERE end_time IS NULL AND user_id = NEW.user_id AND id != NEW.id) THEN
        RAISE EXCEPTION 'Each user can have at most one practice session with end_time IS NULL.';
    END IF;

    -- Return the new row to be updated
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER before_insert_practice_session_trigger
BEFORE INSERT ON practice_sessions
FOR EACH ROW
EXECUTE FUNCTION before_insert_practice_session();

CREATE TRIGGER before_update_practice_session_trigger
BEFORE UPDATE ON practice_sessions
FOR EACH ROW
EXECUTE FUNCTION before_update_practice_session();

ALTER TABLE practice_sessions
ADD duration_seconds INTEGER GENERATED ALWAYS AS (
    CASE
        WHEN end_time IS NOT NULL THEN EXTRACT(EPOCH FROM end_time - start_time)::INTEGER
        ELSE NULL
    END
) STORED;