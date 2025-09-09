#!/usr/bin/env python3
"""
Local SQL Server Database Setup
This script sets up a local SQL Server database with sample data
and provides instructions for connecting to Azure SQL Server.
"""

import pyodbc
import sys

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

def create_sample_database():
    """Create a sample database with typical structure"""
    try:
        database_name = "todda_ai_restored"
        
        # Create database (separate connection with autocommit)
        conn_str = create_connection_string(LOCAL_CONFIG)
        conn = pyodbc.connect(conn_str, timeout=30)
        conn.autocommit = True
        cursor = conn.cursor()
        
        try:
            cursor.execute(f"DROP DATABASE [{database_name}]")
        except:
            pass  # Database might not exist
        cursor.execute(f"CREATE DATABASE [{database_name}]")
        print(f"✓ Created database '{database_name}'")
        conn.close()
        
        # Now connect to the new database
        LOCAL_CONFIG['database'] = database_name
        conn_str = create_connection_string(LOCAL_CONFIG)
        conn = pyodbc.connect(conn_str, timeout=30)
        cursor = conn.cursor()
        
        # Create sample tables
        tables = [
            {
                'name': 'Users',
                'sql': '''
                CREATE TABLE Users (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    name NVARCHAR(100) NOT NULL,
                    email NVARCHAR(100) UNIQUE NOT NULL,
                    phone NVARCHAR(20),
                    created_at DATETIME2 DEFAULT GETDATE(),
                    updated_at DATETIME2 DEFAULT GETDATE()
                )
                '''
            },
            {
                'name': 'Products',
                'sql': '''
                CREATE TABLE Products (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    name NVARCHAR(200) NOT NULL,
                    description NVARCHAR(MAX),
                    price DECIMAL(10,2) NOT NULL,
                    category NVARCHAR(50),
                    stock_quantity INT DEFAULT 0,
                    created_at DATETIME2 DEFAULT GETDATE(),
                    updated_at DATETIME2 DEFAULT GETDATE()
                )
                '''
            },
            {
                'name': 'Orders',
                'sql': '''
                CREATE TABLE Orders (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    user_id INT NOT NULL,
                    total_amount DECIMAL(10,2) NOT NULL,
                    status NVARCHAR(20) DEFAULT 'pending',
                    order_date DATETIME2 DEFAULT GETDATE(),
                    FOREIGN KEY (user_id) REFERENCES Users(id)
                )
                '''
            },
            {
                'name': 'OrderItems',
                'sql': '''
                CREATE TABLE OrderItems (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    order_id INT NOT NULL,
                    product_id INT NOT NULL,
                    quantity INT NOT NULL,
                    unit_price DECIMAL(10,2) NOT NULL,
                    FOREIGN KEY (order_id) REFERENCES Orders(id),
                    FOREIGN KEY (product_id) REFERENCES Products(id)
                )
                '''
            }
        ]
        
        # Create tables
        for table in tables:
            cursor.execute(table['sql'])
            print(f"  ✓ Created table '{table['name']}'")
        
        cursor.commit()
        
        # Insert sample data
        sample_data = [
            {
                'table': 'Users',
                'data': [
                    ('João Silva', 'joao.silva@example.com', '+55 11 99999-9999'),
                    ('Maria Santos', 'maria.santos@example.com', '+55 11 88888-8888'),
                    ('Pedro Oliveira', 'pedro.oliveira@example.com', '+55 11 77777-7777'),
                ]
            },
            {
                'table': 'Products',
                'data': [
                    ('Produto A', 'Descrição do Produto A', 29.99, 'Categoria 1', 100),
                    ('Produto B', 'Descrição do Produto B', 49.99, 'Categoria 2', 50),
                    ('Produto C', 'Descrição do Produto C', 19.99, 'Categoria 1', 200),
                ]
            },
            {
                'table': 'Orders',
                'data': [
                    (1, 79.98, 'completed'),
                    (2, 49.99, 'pending'),
                    (1, 29.99, 'shipped'),
                ]
            },
            {
                'table': 'OrderItems',
                'data': [
                    (1, 1, 2, 29.99),
                    (1, 2, 1, 49.99),
                    (2, 2, 1, 49.99),
                    (3, 1, 1, 29.99),
                ]
            }
        ]
        
        # Insert sample data
        for data_set in sample_data:
            table_name = data_set['table']
            for row in data_set['data']:
                if table_name == 'Users':
                    cursor.execute(f"INSERT INTO [{table_name}] (name, email, phone) VALUES (?, ?, ?)", row)
                elif table_name == 'Products':
                    cursor.execute(f"INSERT INTO [{table_name}] (name, description, price, category, stock_quantity) VALUES (?, ?, ?, ?, ?)", row)
                elif table_name == 'Orders':
                    cursor.execute(f"INSERT INTO [{table_name}] (user_id, total_amount, status) VALUES (?, ?, ?)", row)
                elif table_name == 'OrderItems':
                    cursor.execute(f"INSERT INTO [{table_name}] (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)", row)
            print(f"  ✓ Inserted {len(data_set['data'])} rows into '{table_name}'")
        
        cursor.commit()
        conn.close()
        
        print(f"\n✅ Sample database '{database_name}' created successfully!")
        print(f"   Tables: {', '.join([t['name'] for t in tables])}")
        print(f"   Connection: localhost,1433")
        print(f"   Username: sa")
        print(f"   Password: YourStrong@Passw0rd")
        print(f"   Database: {database_name}")
        
        return True
        
    except Exception as e:
        print(f"✗ Failed to create sample database: {e}")
        return False

def print_azure_instructions():
    """Print instructions for connecting to Azure SQL Server"""
    print("\n" + "="*60)
    print("AZURE SQL SERVER CONNECTION INSTRUCTIONS")
    print("="*60)
    print("\nTo connect to your Azure SQL Server, you need to:")
    print("\n1. Add your IP address to the Azure SQL Server firewall:")
    print("   - Go to Azure Portal")
    print("   - Navigate to your SQL Server: common-tec-prod-brz-bdsql")
    print("   - Go to 'Networking' or 'Firewalls and virtual networks'")
    print("   - Add your current IP address: 200.152.98.151")
    print("   - Save the changes")
    print("\n2. Or use Azure CLI to add firewall rule:")
    print("   az sql server firewall-rule create \\")
    print("     --resource-group <your-resource-group> \\")
    print("     --server common-tec-prod-brz-bdsql \\")
    print("     --name AllowMyIP \\")
    print("     --start-ip-address 200.152.98.151 \\")
    print("     --end-ip-address 200.152.98.151")
    print("\n3. Once firewall is configured, you can run:")
    print("   python3 sql_backup_restore.py")
    print("\n4. Or use the following connection details:")
    print("   Server: common-tec-prod-brz-bdsql.database.windows.net,1433")
    print("   Username: usr_todapraia_pb")
    print("   Password: P8t0d@PR41a")
    print("   Database: [specify your database name]")

def main():
    print("Local SQL Server Database Setup")
    print("=" * 40)
    
    # Test local connection
    print("\n1. Testing local SQL Server connection...")
    local_ok = test_connection(LOCAL_CONFIG, "Local Docker SQL Server")
    
    if not local_ok:
        print("\n❌ Local SQL Server connection failed.")
        print("Make sure Docker container is running: docker-compose up -d sqlserver")
        sys.exit(1)
    
    # Create sample database
    print("\n2. Creating sample database...")
    success = create_sample_database()
    
    if success:
        print("\n✅ Local database setup completed!")
        print_azure_instructions()
    else:
        print("\n❌ Database setup failed.")
        sys.exit(1)

if __name__ == "__main__":
    main()
