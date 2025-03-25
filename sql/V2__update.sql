CREATE TABLE IF NOT EXISTS dbre.sample_data ON CLUSTER my_cluster
(
    id UInt32,
    name String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY id;
