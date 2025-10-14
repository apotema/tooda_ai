module Api
  module V1
    class BarracasOpenapiController < ApplicationController
      include OpenapiRansackMapper

      before_action :set_barraca, only: [:show]

      def index
        ransack_params = build_ransack_params(BARRACA_PARAM_MAP, BARRACA_SORT_MAP)

        @q = Barraca.ransack(ransack_params)
        @barracas = @q.result
                      .includes(:praia, :status_barraca, :tipo_area_cobertura, :tipo_barraca)
                      .page(params[:page])
                      .per(params[:per_page] || 25)

        render json: { barracas: @barracas }, serializer: BarracasOpenapiCollectionSerializer
      end

      # GET /api/v1/barracas_openapi/:id
      def show
        render json: @barraca, serializer: BarracaOpenapiSerializer
      end

      private

      def set_barraca
        @barraca = Barraca.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Barraca not found' }, status: :not_found
      end
    end
  end
end
