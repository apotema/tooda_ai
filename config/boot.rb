ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# Load environment variables from .env if available (works in all envs)
begin
  require 'dotenv/load'
rescue LoadError
  # dotenv not installed; skip
end

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
