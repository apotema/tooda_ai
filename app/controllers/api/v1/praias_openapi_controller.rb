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

        render json: PraiasOpenapiCollectionSerializer.new({ praias: @praias }).serializable_hash
      end

      # GET /api/v1/praias_openapi/:id
      def show
        render json: @praia, serializer: PraiaOpenapiSerializer
      end

      private

      def set_praia
        @praia = Praia.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Praia not found' }, status: :not_found
      end
    end
  end
end
