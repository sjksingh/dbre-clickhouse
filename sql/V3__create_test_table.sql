CREATE TABLE IF NOT EXISTS  dbre.test_stp ON CLUSTER my_cluster
(
    `a` Int32,
    `b` String,
    `c` DateTime
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
PARTITION BY toYYYYMMDD(c)
ORDER BY a;
