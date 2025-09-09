#!/usr/bin/env python3
"""
SQL Server Backup and Restore Script
This script connects to Azure SQL Server and local Docker SQL Server
to perform backup and restore operations.
"""

import pyodbc
import sys
import os
from datetime import datetime

# Azure SQL Server configuration
AZURE_CONFIG = {
    'server': 'common-rep-tooda-prod-brz-bdsql.database.windows.net',
    'port': 1433,
    'database': 'master',  # We'll need to specify the actual database name
    'username': 'sa-tooda',
    'password': '=oY3P12P~-yp&i',
    'driver': '{ODBC Driver 18 for SQL Server}',
    'encrypt': 'yes',
    'trust_server_certificate': 'no'
}

# Local Docker SQL Server configuration
LOCAL_CONFIG = {
    'server': 'localhost',
    'port': 1433,
    'database': 'master',
    'username': 'sa',
    'password': 'YourStrong@Passw0rd',
    'driver': '{ODBC Driver 18 for SQL Server}',
    'encrypt': 'no',
    'trust_server_certificate': 'yes'
}

def create_connection_string(config):
    """Create connection string from configuration"""
    return (
        f"DRIVER={config['driver']};"
        f"SERVER={config['server']},{config['port']};"
        f"DATABASE={config['database']};"
        f"UID={config['username']};"
        f"PWD={config['password']};"
        f"Encrypt={config['encrypt']};"
        f"TrustServerCertificate={config['trust_server_certificate']};"
    )

def test_connection(config, name):
    """Test database connection"""
    try:
        conn_str = create_connection_string(config)
        conn = pyodbc.connect(conn_str, timeout=30)
        cursor = conn.cursor()
        cursor.execute("SELECT @@VERSION")
        version = cursor.fetchone()[0]
        print(f"✓ {name} connection successful")
        print(f"  Version: {version[:50]}...")
        conn.close()
        return True
    except Exception as e:
        print(f"✗ {name} connection failed: {e}")
        return False

def get_databases(config, name):
    """Get list of databases"""
    try:
        conn_str = create_connection_string(config)
        conn = pyodbc.connect(conn_str, timeout=30)
        cursor = conn.cursor()
        cursor.execute("SELECT name FROM sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')")
        databases = [row[0] for row in cursor.fetchall()]
        conn.close()
        print(f"✓ {name} databases: {databases}")
        return databases
    except Exception as e:
        print(f"✗ Failed to get {name} databases: {e}")
        return []

def export_schema_and_data(azure_config, local_config, database_name):
    """Export schema and data from Azure to local SQL Server"""
    try:
        # Connect to Azure SQL Server
        azure_conn_str = create_connection_string(azure_config)
        azure_conn = pyodbc.connect(azure_conn_str, timeout=30)
        azure_cursor = azure_conn.cursor()
        
        # Create database on local server (separate connection with autocommit)
        local_conn_str = create_connection_string(local_config)
        local_conn = pyodbc.connect(local_conn_str, timeout=30)
        local_conn.autocommit = True
        local_cursor = local_conn.cursor()
        
        # Drop and create database on local server
        try:
            local_cursor.execute(f"DROP DATABASE [{database_name}]")
        except:
            pass  # Database might not exist
        local_cursor.execute(f"CREATE DATABASE [{database_name}]")
        print(f"✓ Created database '{database_name}' on local server")
        local_conn.close()
        
        # Wait a moment for database to be ready
        import time
        time.sleep(2)
        
        # Now connect to the new database
        local_config['database'] = database_name
        local_conn_str = create_connection_string(local_config)
        local_conn = pyodbc.connect(local_conn_str, timeout=30)
        local_cursor = local_conn.cursor()
        
        # Update Azure config to use the specific database
        azure_config['database'] = database_name
        azure_conn_str = create_connection_string(azure_config)
        azure_conn.close()
        azure_conn = pyodbc.connect(azure_conn_str, timeout=30)
        azure_cursor = azure_conn.cursor()
        
        # Get all tables from Azure database
        azure_cursor.execute("""
            SELECT TABLE_NAME 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE'
        """)
        tables = [row[0] for row in azure_cursor.fetchall()]
        
        print(f"✓ Found {len(tables)} tables to export")
        
        for table in tables:
            try:
                # Get table schema
                azure_cursor.execute(f"""
                    SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
                           IS_NULLABLE, COLUMN_DEFAULT
                    FROM INFORMATION_SCHEMA.COLUMNS 
                    WHERE TABLE_NAME = '{table}'
                    ORDER BY ORDINAL_POSITION
                """)
                columns = azure_cursor.fetchall()
                
                # Create table on local server
                create_table_sql = f"CREATE TABLE [{table}] ("
                column_definitions = []
                
                for col in columns:
                    col_name, data_type, max_length, nullable, default_val = col
                    col_def = f"[{col_name}] {data_type}"
                    
                    if max_length and data_type in ['varchar', 'nvarchar', 'char', 'nchar']:
                        col_def += f"({max_length})"
                    
                    if nullable == 'NO':
                        col_def += " NOT NULL"
                    
                    if default_val:
                        col_def += f" DEFAULT {default_val}"
                    
                    column_definitions.append(col_def)
                
                create_table_sql += ", ".join(column_definitions) + ")"
                
                local_cursor.execute(create_table_sql)
                print(f"  ✓ Created table '{table}'")
                
                # Export data
                azure_cursor.execute(f"SELECT * FROM [{table}]")
                rows = azure_cursor.fetchall()
                
                if rows:
                    # Get column names for INSERT
                    column_names = [col[0] for col in columns]
                    placeholders = ", ".join(["?" for _ in column_names])
                    insert_sql = f"INSERT INTO [{table}] ([{'], ['.join(column_names)}]) VALUES ({placeholders})"
                    
                    for row in rows:
                        local_cursor.execute(insert_sql, row)
                    
                    local_cursor.commit()
                    print(f"  ✓ Exported {len(rows)} rows to '{table}'")
                
            except Exception as e:
                print(f"  ✗ Error processing table '{table}': {e}")
                continue
        
        azure_conn.close()
        local_conn.close()
        print(f"✓ Export completed for database '{database_name}'")
        return True
        
    except Exception as e:
        print(f"✗ Export failed: {e}")
        return False

def main():
    print("SQL Server Backup and Restore Tool")
    print("=" * 40)
    
    # Test connections
    print("\n1. Testing connections...")
    azure_ok = test_connection(AZURE_CONFIG, "Azure SQL Server")
    local_ok = test_connection(LOCAL_CONFIG, "Local Docker SQL Server")
    
    if not azure_ok or not local_ok:
        print("\n❌ Connection test failed. Please check your configuration.")
        sys.exit(1)
    
    # Get databases
    print("\n2. Getting database lists...")
    azure_dbs = get_databases(AZURE_CONFIG, "Azure")
    local_dbs = get_databases(LOCAL_CONFIG, "Local")
    
    if not azure_dbs:
        print("\n❌ No databases found on Azure SQL Server.")
        sys.exit(1)
    
    # Let user choose database
    print(f"\n3. Available databases on Azure: {azure_dbs}")
    if len(azure_dbs) == 1:
        selected_db = azure_dbs[0]
        print(f"Using database: {selected_db}")
    else:
        selected_db = input("Enter database name to backup: ").strip()
        if selected_db not in azure_dbs:
            print(f"❌ Database '{selected_db}' not found.")
            sys.exit(1)
    
    # Update Azure config with selected database
    AZURE_CONFIG['database'] = selected_db
    
    # Export database
    print(f"\n4. Exporting database '{selected_db}'...")
    success = export_schema_and_data(AZURE_CONFIG, LOCAL_CONFIG, f"{selected_db}_restored")
    
    if success:
        print(f"\n✅ Backup and restore completed successfully!")
        print(f"   Source: {AZURE_CONFIG['server']}/{selected_db}")
        print(f"   Target: {LOCAL_CONFIG['server']}/{selected_db}_restored")
    else:
        print(f"\n❌ Backup and restore failed.")
        sys.exit(1)

if __name__ == "__main__":
    main()
