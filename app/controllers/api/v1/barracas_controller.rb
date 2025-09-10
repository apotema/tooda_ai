module Api
  module V1
    class BarracasController < ApplicationController
      before_action :set_barraca, only: [:show]

      # GET /api/v1/barracas
      # Supports Ransack search parameters via q parameter
      # Example: GET /api/v1/barracas?q[Nome_cont]=beach&q[s]=Nome+asc
      def index
        @barracas = search_barracas
        apply_legacy_filters

        render json: @barracas, each_serializer: BarracaSerializer
      end

      # GET /api/v1/barracas/:id
      def show
        render json: @barraca, serializer: BarracaSerializer
      end

      private

      def set_barraca
        @barraca = Barraca.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Barraca not found' }, status: :not_found
      end

      def search_barracas
        @q = Barraca.ransack(params[:q])
        @q.result.includes(:praia, :status_barraca, :tipo_area_cobertura, :tipo_barraca)
      end

      def apply_legacy_filters
        @barracas = @barracas.where(StatusBarracaId: params[:status_id]) if params[:status_id].present?
        @barracas = @barracas.where(PraiaId: params[:praia_id]) if params[:praia_id].present?
      end
    end
  end
end
