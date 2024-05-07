CREATE TABLE IF NOT EXISTS composers (
    id BIGSERIAL PRIMARY KEY,
    name varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS pieces (
    id BIGSERIAL PRIMARY KEY,
    workName varchar(255) NOT NULL,
    composerId BIGINT,
    userId UUID NOT NULL,
    FOREIGN KEY (userId) REFERENCES auth.users(id),
    FOREIGN KEY (composerId) REFERENCES composers(id)
);

CREATE TABLE IF NOT EXISTS movements (
    id BIGSERIAL PRIMARY KEY,
    pieceId BIGINT NOT NULL,
    name varchar(255),
    number INT,
    FOREIGN KEY (pieceId) REFERENCES pieces(id)
);

-- Enable RLS
ALTER TABLE composers ENABLE ROW LEVEL SECURITY;
ALTER TABLE pieces ENABLE ROW LEVEL SECURITY;
ALTER TABLE movements ENABLE ROW LEVEL SECURITY;

CREATE POLICY auth_read_composers ON composers
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY auth_read_movements ON movements
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY auth_read_pieces ON pieces
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY auth_insert_pieces
    ON pieces
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY auth_insert_movements
    ON movements
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY auth_insert_composers
    ON composers
    FOR INSERT
    TO authenticated
    WITH CHECK (true);