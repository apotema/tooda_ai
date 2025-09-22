# Use distinct internal tables in development when pointing at the same external SQL Server DB as production.
if Rails.env.development?
  ActiveRecord::Base.schema_migrations_table_name = "schema_migrations_dev"
  ActiveRecord::Base.internal_metadata_table_name = "ar_internal_metadata_dev"
end
