# ClickHouse Cluster with Docker

This repository contains configuration files and scripts to set up a ClickHouse cluster with two nodes and ZooKeeper for coordination. It also includes Flyway for database migrations.

## Project Structure

```
.
├── config/
│   ├── config-node1.xml    # Configuration for ClickHouse node1
│   └── config-node2.xml    # Configuration for ClickHouse node2
├── drivers/
│   └── clickhouse-jdbc-0.4.6-all.jar   # JDBC driver for ClickHouse
├── sql/
│   ├── V1__init.sql        # Initial schema setup
│   └── V2__update.sql      # Schema updates
├── docker-compose.yaml     # Docker Compose configuration
├── README.md               # This file
└── .gitignore              # Git ignore file
```

## Prerequisites

- Docker and Docker Compose
- Git

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/clickhouse-cluster.git
   cd clickhouse-cluster
   ```

2. Start the ClickHouse cluster:
   ```bash
   docker-compose up -d
   ```

3. Verify the cluster is running:
   ```bash
   docker-compose ps
   ```

4. Connect to the ClickHouse cluster:
   ```bash
   # Connect to node1
   clickhouse-client --host=localhost --port=9000
   
   # Connect to node2
   clickhouse-client --host=localhost --port=9001
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
   docker-compose down -v
   ```

2. **Connection issues**:
   Make sure ports are not already in use on your host system.

## License

[MIT](LICENSE)
