class BarracasIndexTool < ApplicationTool
  description "List barracas with Ransack filters and pagination. Mirrors GET /api/v1/barracas"

  # Arguments follow Dry::Schema style
  arguments do
    optional(:q).filled(:hash).description("Ransack query hash. Example: { 'Nome_cont' => 'Bar', 's' => 'Nome asc' }")
    optional(:status_id).filled(:string).description("Legacy filter: StatusBarracaId")
    optional(:praia_id).filled(:string).description("Legacy filter: PraiaId")
    optional(:page).filled(:integer).description("Page number (default 1)")
    optional(:per_page).filled(:integer).description("Items per page (default 25)")
  end

  # Returns an array of barracas and pagination metadata
  # Output contract (shape):
  # {
  #   items: [ { barraca fields... includes praia, status_barraca, tipo_area_cobertura, tipo_barraca } ],
  #   pagination: { current_page, next_page, prev_page, total_pages, total_count, per_page }
  # }
  def call(q: {}, status_id: nil, praia_id: nil, page: 1, per_page: 25)
    scope = Barraca.ransack(q).result
                  .includes(:praia, :status_barraca, :tipo_area_cobertura, :tipo_barraca)

    scope = scope.where(StatusBarracaId: status_id) if status_id.present?
    scope = scope.where(PraiaId: praia_id) if praia_id.present?

    paged = scope.page(page).per(per_page || 25)

    result = {
      items: ActiveModel::Serializer::CollectionSerializer.new(
        paged,
        serializer: BarracaSerializer
      ).as_json,
      pagination: {
        current_page: paged.current_page,
        next_page: paged.next_page,
        prev_page: paged.prev_page,
        total_pages: paged.total_pages,
        total_count: paged.total_count,
        per_page: paged.limit_value
      }
    }

    # Log for easy local verification (mirrors SSE content intent)
    McpLogger.log(result, tag: 'BarracasIndexTool')

    result
  end
end
