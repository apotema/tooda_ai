-- Create Rails internal tables on SQL Server if the database is read-only for the app user.
-- Run this once with a user that has sufficient privileges (before setting the DB/user to read-only).

-- Development-specific internal tables (match config/initializers/active_record_internal_tables.rb)
IF NOT EXISTS (
  SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[schema_migrations_dev]') AND type in (N'U')
)
BEGIN
  CREATE TABLE [dbo].[schema_migrations_dev] (
    [version] nvarchar(4000) NOT NULL,
    CONSTRAINT [PK_schema_migrations_dev] PRIMARY KEY CLUSTERED ([version] ASC)
  );
END
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ar_internal_metadata_dev]') AND type in (N'U')
)
BEGIN
  CREATE TABLE [dbo].[ar_internal_metadata_dev] (
    [key] nvarchar(255) NOT NULL,
    [value] nvarchar(255) NULL,
    [created_at] datetime2 NOT NULL,
    [updated_at] datetime2 NOT NULL,
    CONSTRAINT [PK_ar_internal_metadata_dev] PRIMARY KEY CLUSTERED ([key] ASC)
  );
END
GO

-- Ensure an environment row exists (set to 'development' for local dev)
IF NOT EXISTS (SELECT 1 FROM [dbo].[ar_internal_metadata_dev] WHERE [key] = 'environment')
BEGIN
  INSERT INTO [dbo].[ar_internal_metadata_dev] ([key] , [value], [created_at], [updated_at])
  VALUES ('environment', 'development', SYSUTCDATETIME(), SYSUTCDATETIME());
END
GO

-- If running against production environment, change 'development' above to 'production'.
