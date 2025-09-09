-- Create database without Query Store issues
CREATE DATABASE todapraia;
GO

-- Configure basic database settings without problematic Query Store mode
ALTER DATABASE todapraia SET QUERY_STORE = ON (OPERATION_MODE = READ_WRITE);
GO