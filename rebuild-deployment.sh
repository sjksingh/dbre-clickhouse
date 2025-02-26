#!/bin/bash

set -e  # Exit on error
set -u  # Treat unset variables as an error

# Get the current user
CURRENT_USER=$(whoami)

echo "Stopping and cleaning up existing containers and volumes..."
docker-compose down -v

echo "Cleaning up old ZooKeeper, data and ClickHouse logs..."
sudo rm -rf zk-data clickhouse-data clickhouse-logs



echo "Creating fresh directories..."
sudo mkdir -p ./zk-data/zk1/logs ./zk-data/zk2/logs
sudo mkdir -p ./clickhouse-data/node1 ./clickhouse-data/node2
sudo mkdir -p ./clickhouse-logs/node1 ./clickhouse-logs/node2

echo "Starting up ZooKeeper first..."
docker-compose up -d zookeeper1 zookeeper2

# Wait for ZooKeeper to be ready
echo "Waiting for ZooKeeper to be ready..."
for i in {1..10}; do
    if docker exec dbre-clickhouse-zookeeper1-1 zkServer.sh status | grep -q "Mode: standalone"; then
        echo "✅ ZooKeeper is ready!"
        break
    fi
    echo "Still waiting for ZooKeeper..."
    sleep 3
done

echo "Starting up ClickHouse nodes..."
docker-compose up -d node1 node2

echo "Fixing permissions..."
sudo chown -R "$CURRENT_USER":"$CURRENT_USER" ./clickhouse-logs
sudo chown -R "$CURRENT_USER":"$CURRENT_USER" ./zk-data
sudo chown -R "$CURRENT_USER":"$CURRENT_USER" ./clickhouse-data


echo "Starting Flyway Migration container "
docker-compose up -d flyway

echo "✅ Done! ClickHouse and ZooKeeper are fresh and running."
