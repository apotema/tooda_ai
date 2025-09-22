class RansackHelpResource < ApplicationResource
  uri "help:///barracas/ransack"
  resource_name "Barracas Ransack Help"
  description "How to query barracas using Ransack-compatible parameters"
  mime_type "application/json"

  def content
  payload = {
      title: "Barracas Ransack Query Guide",
      base_path: "/api/v1/barracas",
      examples: [
        {
          description: "Find barracas with Nome containing 'Bar' and sort ascending by Nome",
          http: "GET /api/v1/barracas?q[Nome_cont]=Bar&q[s]=Nome+asc",
          mcp_tool: {
            name: "BarracasIndexTool",
            args: { q: { "Nome_cont" => "Bar", "s" => "Nome asc" } }
          }
        },
        {
          description: "Filter by PraiaId and StatusBarracaId (legacy filters)",
          http: "GET /api/v1/barracas?praia_id=1&status_id=4",
          mcp_tool: {
            name: "BarracasIndexTool",
            args: { praia_id: "1", status_id: "4" }
          }
        },
        {
          description: "Paginate with page and per_page",
          http: "GET /api/v1/barracas?page=1&per_page=10",
          mcp_tool: {
            name: "BarracasIndexTool",
            args: { page: 1, per_page: 10 }
          }
        }
      ],
      searchable_attributes: Barraca.ransackable_attributes,
      searchable_associations: Barraca.ransackable_associations,
      tips: [
        "Use *_cont for case-insensitive contains (e.g., Nome_cont)",
        "Use q[s] for sorting (e.g., Nome asc or Nome desc)",
        "Combine filters: q[Nome_cont]=Bar&q[Numero_eq]=112",
        "Available associations: praia, status_barraca, tipo_area_cobertura, tipo_barraca"
      ]
  }

  McpLogger.log(payload, tag: 'RansackHelpResource')
  JSON.generate(payload)
  end
end
