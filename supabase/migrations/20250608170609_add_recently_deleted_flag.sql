ALTER TABLE practice_sessions
ADD COLUMN deleted_at timestamp DEFAULT NULL;

CREATE INDEX index_practice_sessions_on_deleted_at ON practice_sessions(deleted_at);
