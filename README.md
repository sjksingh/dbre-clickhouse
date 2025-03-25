# ClickHouse Cluster with Docker

This repository contains configuration files and scripts to set up a ClickHouse cluster with two nodes and ZooKeeper for coordination. It also includes Flyway for database migrations.

## Project Structure

```
.
├── config/
│   ├── config-node1.xml    # Configuration for ClickHouse node1
│   ├── config-node2.xml    # Configuration for ClickHouse node2
│   └── users.xml           # User configuration for ClickHouse
├── drivers/
│   └── clickhouse-jdbc-0.4.6-all.jar   # JDBC driver for ClickHouse
├── sql/
│   ├── V1__init.sql        # Initial schema setup
│   ├── V2__update.sql      # Schema updates
│   ├── V3__create_test_table.sql  # SQL for creating a test table
│   └── V4__insert_test_table.sql  # SQL for inserting data into the test table
├── docker-compose.yaml     # Docker Compose configuration
├── README.md               # This file
├── .gitignore              # Git ignore file
├── rebuild-deployment.sh   # Script for rebuilding the deployment
├── zk-data/                # Zookeeper data directory
└── clickhouse-logs/        # ClickHouse logs directory
    ├── node1               # Logs for ClickHouse node1
    └── node2               # Logs for ClickHouse node2
```

## Prerequisites

- Docker and Docker Compose
- Git

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/sjksingh/dbre-clickhouse.git
   cd dbre-clickhouse
   ```

2. Start the ClickHouse cluster:
   ```bash
   rebuild-deployment.sh
   ```

3. Verify the cluster is running:
   ```bash
   docker-compose ps
   ```

4. Connect to the ClickHouse cluster:
   ```bash
   # Connect to node1 using default user
   docker exec -it dbre-clickhouse-node1-1 clickhouse-client --host node1
   
   # Connect to node2 using default user
   docker exec -it dbre-clickhouse-node2-1 clickhouse-client --host node2

   #Connect to node1 using dbre user
   docker exec -it dbre-clickhouse-node1-1 clickhouse-client --host node1 --port 9000 --user dbre --password dbre123

   #Connect to node2 using dbre user
   docker exec -it dbre-clickhouse-node2-1 clickhouse-client --host node1 --port 9000 --user dbre --password dbre123
   
   ```

## Configuration

The cluster is configured with:
- Two ClickHouse nodes (node1, node2) forming a single shard with replication
- ZooKeeper for coordination
- Performance optimizations:
  - 50 max connections
  - 100 max concurrent queries
  - 2GB uncompressed cache
  - 1GB mark cache

## Database Migrations

Flyway is configured to execute SQL migrations against the ClickHouse cluster. Migration files are located in the `sql/` directory.

To manually trigger migrations:
```bash
docker-compose up flyway
```


## Troubleshooting

### Common Issues

1. **Replica already exists error**:
   This can happen if ZooKeeper already has data from a previous deployment. Clean up with: 
   ```bash
   rebuild-deployment.sh
   ```

2. ** To see logs:
  ```bash
  docker-compose  logs flyway
  docker logs dbre-clickhouse-node1-1 --tail 50
  docker logs dbre-clickhouse-node2-1 --tail 50
  dbre-clickhouse/clickhouse-logs - has logs for both nodes.
```
## License

[MIT](LICENSE)
