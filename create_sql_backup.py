#!/usr/bin/env python3
"""
Create SQL Backup File from Local SQL Server
This script creates a SQL backup file from the local Docker SQL Server database
"""

import pyodbc
import sys
import os
from datetime import datetime

# Local Docker SQL Server configuration
LOCAL_CONFIG = {
    'server': 'localhost',
    'port': 1433,
    'database': 'todapraia_backup',
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

def test_connection():
    """Test database connection"""
    try:
        conn_str = create_connection_string(LOCAL_CONFIG)
        conn = pyodbc.connect(conn_str, timeout=30)
        cursor = conn.cursor()
        cursor.execute("SELECT @@VERSION")
        version = cursor.fetchone()[0]
        print(f"✓ Connected to local SQL Server: {version[:50]}...")
        conn.close()
        return True
    except Exception as e:
        print(f"✗ Connection failed: {e}")
        return False

def get_tables():
    """Get list of tables from the database"""
    try:
        conn_str = create_connection_string(LOCAL_CONFIG)
        conn = pyodbc.connect(conn_str, timeout=30)
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT TABLE_NAME 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE'
            ORDER BY TABLE_NAME
        """)
        tables = [row[0] for row in cursor.fetchall()]
        conn.close()
        
        print(f"✓ Found {len(tables)} tables in database")
        return tables
    except Exception as e:
        print(f"✗ Failed to get tables: {e}")
        return []

def get_table_schema(table_name):
    """Get table schema information"""
    try:
        conn_str = create_connection_string(LOCAL_CONFIG)
        conn = pyodbc.connect(conn_str, timeout=30)
        cursor = conn.cursor()
        
        cursor.execute(f"""
            SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
                   IS_NULLABLE, COLUMN_DEFAULT, ORDINAL_POSITION
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = '{table_name}'
            ORDER BY ORDINAL_POSITION
        """)
        columns = cursor.fetchall()
        conn.close()
        
        return columns
    except Exception as e:
        print(f"  ⚠ Error getting schema for {table_name}: {e}")
        return []

def get_table_data(table_name):
    """Get all data from a table"""
    try:
        conn_str = create_connection_string(LOCAL_CONFIG)
        conn = pyodbc.connect(conn_str, timeout=30)
        cursor = conn.cursor()
        
        cursor.execute(f"SELECT * FROM [{table_name}]")
        rows = cursor.fetchall()
        conn.close()
        
        return rows
    except Exception as e:
        print(f"  ⚠ Error getting data from {table_name}: {e}")
        return []

def escape_sql_value(value):
    """Escape SQL values for safe insertion"""
    if value is None:
        return 'NULL'
    elif isinstance(value, str):
        # Escape single quotes and wrap in quotes
        escaped = value.replace("'", "''")
        return f"'{escaped}'"
    elif isinstance(value, (int, float)):
        return str(value)
    elif isinstance(value, bool):
        return '1' if value else '0'
    else:
        return f"'{str(value).replace("'", "''")}'"

def create_sql_backup_file(tables, backup_file):
    """Create SQL backup file with schema and data"""
    try:
        with open(backup_file, 'w', encoding='utf-8') as f:
            # Write header
            f.write("-- SQL Server Database Backup\n")
            f.write(f"-- Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"-- Database: {LOCAL_CONFIG['database']}\n")
            f.write(f"-- Tables: {len(tables)}\n")
            f.write("--\n\n")
            
            # Set database context
            f.write(f"USE [{LOCAL_CONFIG['database']}];\n\n")
            
            # Process each table
            for i, table_name in enumerate(tables, 1):
                print(f"Processing table {i}/{len(tables)}: {table_name}")
                
                # Get table schema
                columns = get_table_schema(table_name)
                if not columns:
                    f.write(f"-- Table {table_name}: Schema not available\n\n")
                    continue
                
                # Write table creation script
                f.write(f"-- Table: {table_name}\n")
                f.write(f"IF OBJECT_ID('[{table_name}]', 'U') IS NOT NULL\n")
                f.write(f"    DROP TABLE [{table_name}];\n\n")
                
                f.write(f"CREATE TABLE [{table_name}] (\n")
                
                column_definitions = []
                for col in columns:
                    col_name, data_type, max_length, nullable, default_val, ordinal = col
                    col_def = f"    [{col_name}] {data_type}"
                    
                    if max_length and data_type in ['varchar', 'nvarchar', 'char', 'nchar']:
                        col_def += f"({max_length})"
                    
                    if nullable == 'NO':
                        col_def += " NOT NULL"
                    
                    if default_val:
                        col_def += f" DEFAULT {default_val}"
                    
                    column_definitions.append(col_def)
                
                f.write(",\n".join(column_definitions))
                f.write("\n);\n\n")
                
                # Get table data
                rows = get_table_data(table_name)
                if rows:
                    f.write(f"-- Data for table: {table_name} ({len(rows)} rows)\n")
                    
                    # Get column names
                    column_names = [col[0] for col in columns]
                    
                    # Write INSERT statements in batches
                    batch_size = 1000
                    for batch_start in range(0, len(rows), batch_size):
                        batch_end = min(batch_start + batch_size, len(rows))
                        batch_rows = rows[batch_start:batch_end]
                        
                        f.write(f"INSERT INTO [{table_name}] ([{'], ['.join(column_names)}]) VALUES\n")
                        
                        value_lines = []
                        for row in batch_rows:
                            values = [escape_sql_value(value) for value in row]
                            value_lines.append(f"    ({', '.join(values)})")
                        
                        f.write(",\n".join(value_lines))
                        f.write(";\n\n")
                    
                    print(f"  ✓ Exported {len(rows)} rows")
                else:
                    f.write(f"-- Table {table_name} is empty\n\n")
                    print(f"  ✓ Table is empty")
                
                f.write("\n")
            
            f.write("-- Backup completed\n")
        
        print(f"\n✅ SQL backup file created: {backup_file}")
        return True
        
    except Exception as e:
        print(f"✗ Failed to create backup file: {e}")
        return False

def main():
    print("SQL Server Database Backup File Creator")
    print("=" * 50)
    
    # Test connection
    if not test_connection():
        print("\n❌ Connection test failed. Exiting.")
        sys.exit(1)
    
    # Get tables
    print("\nGetting tables from database...")
    tables = get_tables()
    if not tables:
        print("❌ No tables found in database. Exiting.")
        sys.exit(1)
    
    # Create backup file
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = f"todapraia_backup_{timestamp}.sql"
    
    print(f"\nCreating SQL backup file: {backup_file}")
    print(f"Processing {len(tables)} tables...")
    
    success = create_sql_backup_file(tables, backup_file)
    
    if success:
        # Get file size
        file_size = os.path.getsize(backup_file)
        file_size_mb = file_size / (1024 * 1024)
        
        print(f"\n✅ Backup completed successfully!")
        print(f"   File: {backup_file}")
        print(f"   Size: {file_size_mb:.2f} MB")
        print(f"   Tables: {len(tables)}")
        print(f"\nTo restore this backup, you can:")
        print(f"   1. Use SQL Server Management Studio")
        print(f"   2. Use sqlcmd: sqlcmd -S localhost,1433 -U sa -P YourStrong@Passw0rd -i {backup_file}")
        print(f"   3. Use Azure Data Studio")
    else:
        print("\n❌ Backup failed.")
        sys.exit(1)

if __name__ == "__main__":
    main()

