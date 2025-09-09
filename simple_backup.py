#!/usr/bin/env python3
"""
Simple Azure SQL Server Backup to Local Docker
This script exports data from Azure SQL Server to local Docker SQL Server
"""

import pyodbc
import sys
import time

# Azure SQL Server configuration
AZURE_CONFIG = {
    'server': 'common-rep-tooda-prod-brz-bdsql.database.windows.net',
    'port': 1433,
    'database': 'todapraia',
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

def test_connections():
    """Test both database connections"""
    print("Testing connections...")
    
    # Test Azure connection
    try:
        azure_conn_str = create_connection_string(AZURE_CONFIG)
        azure_conn = pyodbc.connect(azure_conn_str, timeout=30)
        azure_cursor = azure_conn.cursor()
        azure_cursor.execute("SELECT @@VERSION")
        version = azure_cursor.fetchone()[0]
        print(f"✓ Azure SQL Server connected: {version[:50]}...")
        azure_conn.close()
    except Exception as e:
        print(f"✗ Azure connection failed: {e}")
        return False
    
    # Test Local connection
    try:
        local_conn_str = create_connection_string(LOCAL_CONFIG)
        local_conn = pyodbc.connect(local_conn_str, timeout=30)
        local_cursor = local_conn.cursor()
        local_cursor.execute("SELECT @@VERSION")
        version = local_cursor.fetchone()[0]
        print(f"✓ Local SQL Server connected: {version[:50]}...")
        local_conn.close()
    except Exception as e:
        print(f"✗ Local connection failed: {e}")
        return False
    
    return True

def get_tables_from_azure():
    """Get list of tables from Azure database"""
    try:
        azure_conn_str = create_connection_string(AZURE_CONFIG)
        azure_conn = pyodbc.connect(azure_conn_str, timeout=30)
        azure_cursor = azure_conn.cursor()
        
        azure_cursor.execute("""
            SELECT TABLE_NAME 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE'
            ORDER BY TABLE_NAME
        """)
        tables = [row[0] for row in azure_cursor.fetchall()]
        azure_conn.close()
        
        print(f"✓ Found {len(tables)} tables in Azure database: {tables}")
        return tables
    except Exception as e:
        print(f"✗ Failed to get tables from Azure: {e}")
        return []

def create_local_database():
    """Create local database for the backup"""
    try:
        local_conn_str = create_connection_string(LOCAL_CONFIG)
        local_conn = pyodbc.connect(local_conn_str, timeout=30)
        local_conn.autocommit = True
        local_cursor = local_conn.cursor()
        
        database_name = "todapraia_backup"
        
        # Drop if exists and create new database
        try:
            local_cursor.execute(f"DROP DATABASE [{database_name}]")
        except:
            pass
        
        local_cursor.execute(f"CREATE DATABASE [{database_name}]")
        print(f"✓ Created local database: {database_name}")
        local_conn.close()
        
        return database_name
    except Exception as e:
        print(f"✗ Failed to create local database: {e}")
        return None

def export_table_data(table_name, local_database):
    """Export data from Azure table to local database"""
    try:
        # Connect to Azure
        azure_conn_str = create_connection_string(AZURE_CONFIG)
        azure_conn = pyodbc.connect(azure_conn_str, timeout=30)
        azure_cursor = azure_conn.cursor()
        
        # Connect to local database
        local_config = LOCAL_CONFIG.copy()
        local_config['database'] = local_database
        local_conn_str = create_connection_string(local_config)
        local_conn = pyodbc.connect(local_conn_str, timeout=30)
        local_cursor = local_conn.cursor()
        
        # Get table schema from Azure
        azure_cursor.execute(f"""
            SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
                   IS_NULLABLE, COLUMN_DEFAULT, ORDINAL_POSITION
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = '{table_name}'
            ORDER BY ORDINAL_POSITION
        """)
        columns = azure_cursor.fetchall()
        
        if not columns:
            print(f"  ⚠ No columns found for table {table_name}")
            return False
        
        # Create table on local server
        create_table_sql = f"CREATE TABLE [{table_name}] ("
        column_definitions = []
        
        for col in columns:
            col_name, data_type, max_length, nullable, default_val, ordinal = col
            col_def = f"[{col_name}] {data_type}"
            
            if max_length and data_type in ['varchar', 'nvarchar', 'char', 'nchar']:
                col_def += f"({max_length})"
            
            if nullable == 'NO':
                col_def += " NOT NULL"
            
            if default_val:
                col_def += f" DEFAULT {default_val}"
            
            column_definitions.append(col_def)
        
        create_table_sql += ", ".join(column_definitions) + ")"
        
        try:
            local_cursor.execute(create_table_sql)
            print(f"  ✓ Created table '{table_name}'")
        except Exception as e:
            print(f"  ⚠ Error creating table '{table_name}': {e}")
            return False
        
        # Export data
        try:
            azure_cursor.execute(f"SELECT * FROM [{table_name}]")
            rows = azure_cursor.fetchall()
            
            if rows:
                # Get column names for INSERT
                column_names = [col[0] for col in columns]
                placeholders = ", ".join(["?" for _ in column_names])
                insert_sql = f"INSERT INTO [{table_name}] ([{'], ['.join(column_names)}]) VALUES ({placeholders})"
                
                for row in rows:
                    try:
                        local_cursor.execute(insert_sql, row)
                    except Exception as e:
                        print(f"    ⚠ Error inserting row: {e}")
                        continue
                
                local_cursor.commit()
                print(f"  ✓ Exported {len(rows)} rows to '{table_name}'")
            else:
                print(f"  ✓ Table '{table_name}' is empty")
            
        except Exception as e:
            print(f"  ⚠ Error exporting data from '{table_name}': {e}")
            return False
        
        azure_conn.close()
        local_conn.close()
        return True
        
    except Exception as e:
        print(f"  ✗ Failed to export table '{table_name}': {e}")
        return False

def main():
    print("Azure SQL Server to Local Docker Backup")
    print("=" * 50)
    
    # Test connections
    if not test_connections():
        print("\n❌ Connection test failed. Exiting.")
        sys.exit(1)
    
    # Get tables from Azure
    print("\nGetting tables from Azure database...")
    tables = get_tables_from_azure()
    if not tables:
        print("❌ No tables found in Azure database. Exiting.")
        sys.exit(1)
    
    # Create local database
    print("\nCreating local database...")
    local_database = create_local_database()
    if not local_database:
        print("❌ Failed to create local database. Exiting.")
        sys.exit(1)
    
    # Export each table
    print(f"\nExporting {len(tables)} tables...")
    success_count = 0
    
    for table in tables:
        print(f"\nExporting table: {table}")
        if export_table_data(table, local_database):
            success_count += 1
    
    print(f"\n✅ Backup completed!")
    print(f"   Successfully exported: {success_count}/{len(tables)} tables")
    print(f"   Local database: {local_database}")
    print(f"   Connection: localhost,1433")
    print(f"   Username: sa")
    print(f"   Password: YourStrong@Passw0rd")

if __name__ == "__main__":
    main()

