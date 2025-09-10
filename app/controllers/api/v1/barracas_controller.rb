module Api
  module V1
    class BarracasController < ApplicationController
      before_action :set_barraca, only: [:show]

      # GET /api/v1/barracas
      # Supports Ransack search parameters via q parameter
      # Supports pagination via page and per_page parameters
      # Example: GET /api/v1/barracas?q[Nome_cont]=beach&q[s]=Nome+asc&page=1&per_page=10
      def index
        @barracas = search_barracas
        apply_legacy_filters
        @barracas = @barracas.page(params[:page]).per(params[:per_page] || 25)

        add_pagination_headers
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

      def add_pagination_headers
        response.headers['X-Current-Page'] = @barracas.current_page.to_s
        response.headers['X-Next-Page'] = @barracas.next_page.to_s if @barracas.next_page
        response.headers['X-Prev-Page'] = @barracas.prev_page.to_s if @barracas.prev_page
        response.headers['X-Total-Pages'] = @barracas.total_pages.to_s
        response.headers['X-Total-Count'] = @barracas.total_count.to_s
        response.headers['X-Per-Page'] = @barracas.limit_value.to_s
      end
    end
  end
end
