-- Feature Registry Schema (Rule #11: Give feature columns owners)
-- Author: Kenneth Dallmier | kennydallmier@gmail.com
-- Repository: feature-registry

CREATE TABLE IF NOT EXISTS feature_registry (
    feature_id          SERIAL PRIMARY KEY,
    feature_name        VARCHAR(255) NOT NULL UNIQUE,
    owner_email         VARCHAR(255) NOT NULL,
    backup_owner_email  VARCHAR(255),
    description         TEXT NOT NULL,
    data_type           VARCHAR(50) NOT NULL DEFAULT 'FLOAT',
    expected_coverage_pct DECIMAL(5,2) NOT NULL DEFAULT 100.0,
    status              VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
                            CHECK (status IN ('ACTIVE', 'DEPRECATED', 'EXPERIMENTAL')),
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_used_at        TIMESTAMP WITH TIME ZONE,
    notes               TEXT
);

CREATE INDEX idx_feature_registry_status ON feature_registry(status);
CREATE INDEX idx_feature_registry_owner ON feature_registry(owner_email);
CREATE INDEX idx_feature_registry_name ON feature_registry(feature_name);

-- Trigger to auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_feature_registry_updated_at
    BEFORE UPDATE ON feature_registry
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column();

-- Seed: Core MLAOS features (Kenneth Dallmier, owner)
INSERT INTO feature_registry (
    feature_name, owner_email, backup_owner_email,
    description, data_type, expected_coverage_pct, status, notes
) VALUES
(
    'resonance_score',
    'kennydallmier@gmail.com',
    'kennydallmier@gmail.com',
    'Emotional resonance of memory node, normalized 0.0-1.0. Higher = stronger emotional activation.',
    'FLOAT', 100.0, 'ACTIVE',
    'Core feature for MLAOS memory ranking. Extracted by FeatureExtractor.extract_features().'
),
(
    'chiaroscuro_index',
    'kennydallmier@gmail.com',
    'kennydallmier@gmail.com',
    'Light/dark contrast ratio for memory polarization. 0.0 = pure dark, 1.0 = pure light.',
    'FLOAT', 100.0, 'ACTIVE',
    'Named after chiaroscuro art technique. Represents polarity of memory activation.'
),
(
    'memory_vector',
    'kennydallmier@gmail.com',
    'kennydallmier@gmail.com',
    'Unit-normalized embedding vector representing memory node position in latent space.',
    'ARRAY', 100.0, 'ACTIVE',
    'Dimension varies by model version. Always unit-normalized before storage.'
),
(
    'archetype_alignment',
    'kennydallmier@gmail.com',
    'kennydallmier@gmail.com',
    'Cosine similarity to nearest Jungian archetype in the MLAOS archetype space (0.0-1.0).',
    'FLOAT', 95.0, 'ACTIVE',
    '95% coverage expected due to edge cases in archetype assignment. Null = unclassified.'
)
ON CONFLICT (feature_name) DO NOTHING;

-- View: Active features with owner summary
CREATE OR REPLACE VIEW active_features_view AS
SELECT
    feature_name,
    owner_email,
    data_type,
    expected_coverage_pct,
    status,
    created_at,
    last_used_at
FROM feature_registry
WHERE status = 'ACTIVE'
ORDER BY feature_name;
