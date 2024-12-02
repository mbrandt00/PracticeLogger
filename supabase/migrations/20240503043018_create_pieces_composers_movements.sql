comment on schema public is e'@graphql({"inflect_names": true})';
CREATE TABLE IF NOT EXISTS composers (
    id BIGSERIAL PRIMARY KEY,
    name varchar(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS pieces (
    id BIGSERIAL PRIMARY KEY,
    work_name varchar(255) NOT NULL,
    composer_id BIGINT,
    nickname text,
    user_id UUID NOT NULL DEFAULT auth.uid(),
    FOREIGN KEY (user_id) REFERENCES auth.users(id),
    FOREIGN KEY (composer_id) REFERENCES composers(id)
);
CREATE TABLE IF NOT EXISTS movements (
    id BIGSERIAL PRIMARY KEY,
    piece_id BIGINT NOT NULL,
    name varchar(255),
    number INT,
    FOREIGN KEY (piece_id) REFERENCES pieces(id)
);
-- Enable RLS
ALTER TABLE composers ENABLE ROW LEVEL SECURITY;
ALTER TABLE pieces ENABLE ROW LEVEL SECURITY;
ALTER TABLE movements ENABLE ROW LEVEL SECURITY;
CREATE POLICY auth_read_composers ON composers FOR
SELECT TO authenticated USING (true);
CREATE POLICY auth_read_movements ON movements FOR
SELECT TO authenticated USING (true);
CREATE POLICY auth_read_pieces ON pieces FOR
SELECT TO authenticated USING (true);
CREATE POLICY auth_insert_pieces ON pieces FOR
INSERT TO authenticated WITH CHECK (true);
CREATE POLICY auth_insert_movements ON movements FOR
INSERT TO authenticated WITH CHECK (true);
CREATE POLICY auth_insert_composers ON composers FOR
INSERT TO authenticated WITH CHECK (true);
