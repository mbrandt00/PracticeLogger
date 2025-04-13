drop view public.user_unique_piece_sessions_v;

ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
CREATE POLICY auth_read_collections ON collections FOR
SELECT TO authenticated USING (true);

