ALTER TABLE practice_sessions
ADD COLUMN deleted boolean default false;


CREATE INDEX practice_sessions_not_deleted_idx
ON practice_sessions(id)
WHERE deleted = false;
