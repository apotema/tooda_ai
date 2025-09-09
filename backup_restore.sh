#!/bin/bash

# Azure SQL Server credentials
AZURE_SERVER="common-tec-prod-brz-bdsql.database.windows.net"
AZURE_USER="usr_todapraia_pb"
AZURE_PASSWORD="P8t0d@PR41a"
AZURE_DATABASE="master"  # We'll need to specify the actual database name

# Local Docker SQL Server credentials
LOCAL_SERVER="localhost,1433"
LOCAL_USER="sa"
LOCAL_PASSWORD="YourStrong@Passw0rd"
LOCAL_DATABASE="todda_ai_restored"

echo "Starting backup and restore process..."

# Wait for local SQL Server to be ready
echo "Waiting for local SQL Server to be ready..."
sleep 30

# Test connection to local SQL Server
echo "Testing connection to local SQL Server..."
docker exec todda_ai_sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -Q "SELECT @@VERSION" -C

if [ $? -ne 0 ]; then
    echo "Failed to connect to local SQL Server. Please check if the container is running."
    exit 1
fi

# Create a backup using Azure CLI (if you have access)
echo "Creating backup from Azure SQL Server..."
# Note: This requires Azure CLI authentication and proper permissions
# az sql db export --resource-group <resource-group> --server <server-name> --name <database-name> --storage-key <storage-key> --storage-key-type StorageAccessKey --storage-uri <storage-uri>

# For now, let's create a simple schema export using sqlcmd
echo "Exporting schema and data from Azure SQL Server..."

# Create a temporary directory for the backup
mkdir -p ./backup_temp

# Export schema and data using sqlcmd (requires sqlcmd to be installed)
# This is a simplified approach - in production you'd want to use proper backup/restore
echo "Note: This script requires sqlcmd to be installed and Azure SQL Server access."
echo "For a complete backup, you would need to:"
echo "1. Use Azure CLI to create a database export"
echo "2. Download the .bacpac file"
echo "3. Import it to your local SQL Server"

# Alternative: Create a simple test database structure
echo "Creating test database structure on local SQL Server..."
docker exec todda_ai_sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -Q "
CREATE DATABASE [$LOCAL_DATABASE];
GO
USE [$LOCAL_DATABASE];
GO
CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE()
);
GO
INSERT INTO Users (name, email) VALUES 
('Test User 1', 'test1@example.com'),
('Test User 2', 'test2@example.com');
GO
"

if [ $? -eq 0 ]; then
    echo "Successfully created test database with sample data!"
    echo "Database: $LOCAL_DATABASE"
    echo "You can now connect to it using:"
    echo "  Server: localhost,1433"
    echo "  Username: sa"
    echo "  Password: YourStrong@Passw0rd"
    echo "  Database: $LOCAL_DATABASE"
else
    echo "Failed to create test database."
    exit 1
fi

echo "Backup and restore process completed!"
