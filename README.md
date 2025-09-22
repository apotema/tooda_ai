# Todda AI

A Rails application with SQL Server database support.

## Prerequisites

* Ruby 3.3+
* Docker and Docker Compose
* FreeTDS (for SQL Server connectivity)

## Quick Start

1. **Start the database services:**
   ```bash
   docker-compose up -d
   ```

2. **Set up environment variables:**
   Create a `.env` file with the following variables:
   ```bash
   SQLSERVER_HOST=localhost
   SQLSERVER_PORT=1433
   SQLSERVER_DATABASE=todda_ai_development
   SQLSERVER_USERNAME=sa
   SQLSERVER_PASSWORD=YourStrong@Passw0rd
   SQLSERVER_DATABASE_TEST=todda_ai_test
   ```

3. **Install dependencies:**
   ```bash
   bundle install
   ```

4. **Configure database:**
   To use SQL Server, uncomment the relevant environment block in `config/database.yml` and set the environment variables.

5. **Create and migrate database:**
   ```bash
   rails db:create
   rails db:migrate
   ```

6. **Start the Rails server:**
   ```bash
   rails server
   ```

## Database Services

The `docker-compose.yml` file includes:
- **SQL Server 2022 Express**: Available on port 1433
- **Redis**: Available on port 6379 (for caching and background jobs)

Default SQL Server credentials:
- Username: `sa`
- Password: `YourStrong@Passw0rd`

## Configuration

The application supports both SQLite (default) and SQL Server databases. To switch to SQL Server, update the environment configuration in `config/database.yml` and set the required environment variables.

## MCP server (fast-mcp)

This app exposes an MCP server for AI clients (Claude, ChatGPT via MCP) using the fast-mcp gem.

- Endpoints mounted under `/mcp`:
   - `/mcp/messages` (HTTP messages)
   - `/mcp/sse` (Server-Sent Events)

Registered tools/resources:
- Tool: `BarracasIndexTool` — lists barracas with Ransack filters and pagination. Arguments:
   - `q` (hash): Ransack params, e.g. `{ "Nome_cont" => "Bar", "s" => "Nome asc" }`
   - `praia_id`, `status_id` (strings): legacy filters
   - `page`, `per_page` (integers): pagination
- Resource: `help:///barracas/ransack` — JSON guide with examples, searchable attributes and associations.

Quick test with MCP Inspector:
1) Start Rails server.
2) Run MCP Inspector (SSE) and point it to `http://localhost:3000/mcp/sse`.
3) Discover tools, call `BarracasIndexTool` with `{ q: { "Nome_cont": "Bar", "s": "Nome asc" }, page: 1, per_page: 10 }`.
