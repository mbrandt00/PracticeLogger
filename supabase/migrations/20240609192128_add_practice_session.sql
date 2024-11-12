CREATE TABLE IF NOT EXISTS practice_sessions (
    id BIGSERIAL PRIMARY KEY,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    piece_id BIGINT NOT NULL,
    movement_id BIGINT,
    user_id UUID NOT NULL DEFAULT auth.uid(),
    FOREIGN KEY (user_id) REFERENCES auth.users(id),
    FOREIGN KEY (movement_id) REFERENCES movements(id),
    FOREIGN KEY (piece_id) REFERENCES pieces(id)
);
ALTER TABLE practice_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY auth_insert_practice_sessions ON practice_sessions FOR
INSERT TO authenticated WITH CHECK (true);
CREATE POLICY auth_read_practice_sessions ON practice_sessions FOR
SELECT TO authenticated USING (true);
CREATE POLICY auth_update_practice_sessions ON practice_sessions FOR
UPDATE TO authenticated USING (user_id = auth.uid());
CREATE POLICY auth_delete_practice_sessions ON practice_sessions FOR DELETE TO authenticated USING (user_id = auth.uid());
-- realtime 
alter publication supabase_realtime
add table practice_sessions;
