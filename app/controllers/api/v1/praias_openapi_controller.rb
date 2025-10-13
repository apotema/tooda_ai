module Api
  module V1
    class PraiasOpenapiController < ApplicationController
      include OpenapiRansackMapper

      before_action :set_praia, only: [:show]

      def index
        ransack_params = build_ransack_params(PRAIA_PARAM_MAP, PRAIA_SORT_MAP)

        @q = Praia.ransack(ransack_params)
        @praias = @q.result
                    .page(params[:page])
                    .per(params[:per_page] || 25)

        add_pagination_headers
        render json: @praias, each_serializer: PraiaSerializer
      end

      # GET /api/v1/praias_openapi/:id
      def show
        render json: @praia, serializer: PraiaSerializer
      end

      private

      def set_praia
        @praia = Praia.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Praia not found' }, status: :not_found
      end

      def add_pagination_headers
        response.headers['X-Current-Page'] = @praias.current_page.to_s
        response.headers['X-Next-Page'] = @praias.next_page.to_s if @praias.next_page
        response.headers['X-Prev-Page'] = @praias.prev_page.to_s if @praias.prev_page
        response.headers['X-Total-Pages'] = @praias.total_pages.to_s
        response.headers['X-Total-Count'] = @praias.total_count.to_s
        response.headers['X-Per-Page'] = @praias.limit_value.to_s
      end
    end
  end
end
