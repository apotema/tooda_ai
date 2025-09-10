require 'rails_helper'

RSpec.describe 'Api::V1::Barracas', type: :request do
  let(:praia) { create(:praia) }

  describe 'GET /api/v1/barracas' do
    before do
      create(:barraca, Nome: 'Barraca Sol', PraiaId: praia.Id)
      create(:barraca, Nome: 'Barraca Mar', PraiaId: praia.Id)
      create(:barraca, Nome: 'Quiosque Praia')
    end

    context 'without filters' do
      before { get '/api/v1/barracas' }

      it 'returns all barracas with valid schema' do
        expect(response).to have_http_status(:ok).and match_json_schema('barracas')
      end

      it 'returns correct number of barracas' do
        expect(response.parsed_body.size).to eq(3)
      end

      it 'includes associated data' do
        expect(response.parsed_body.first).to include(
          'praia', 'status_barraca', 'tipo_area_cobertura', 'tipo_barraca'
        )
      end
    end

    context 'with Ransack search' do
      it 'filters by name containing text' do
        get '/api/v1/barracas', params: { q: { Nome_cont: 'Sol' } }
        expect(response).to have_http_status(:ok).and match_json_schema('barracas')
      end

      it 'returns correct barraca for name containing filter' do
        get '/api/v1/barracas', params: { q: { Nome_cont: 'Sol' } }
        expect(response.parsed_body.first['Nome']).to eq('Barraca Sol')
      end

      it 'filters by name starting with text' do
        get '/api/v1/barracas', params: { q: { Nome_start: 'Barraca' } }
        expect(response).to have_http_status(:ok).and match_json_schema('barracas')
      end

      it 'returns correct barracas for name starting filter' do
        get '/api/v1/barracas', params: { q: { Nome_start: 'Barraca' } }
        expect(response.parsed_body.pluck('Nome')).to contain_exactly('Barraca Sol', 'Barraca Mar')
      end

      it 'sorts by name ascending' do
        get '/api/v1/barracas', params: { q: { s: 'Nome asc' } }
        expect(response).to have_http_status(:ok).and match_json_schema('barracas')
      end

      it 'sorts by name descending' do
        get '/api/v1/barracas', params: { q: { s: 'Nome desc' } }
        expect(response).to have_http_status(:ok).and match_json_schema('barracas')
      end

      it 'combines multiple search criteria' do
        get '/api/v1/barracas', params: { q: { Nome_cont: 'Barraca', PraiaId_eq: praia.Id } }
        expect(response).to have_http_status(:ok).and match_json_schema('barracas')
      end

      it 'returns only barracas matching combined criteria' do
        get '/api/v1/barracas', params: { q: { Nome_cont: 'Barraca', PraiaId_eq: praia.Id } }
        expect(response.parsed_body.all? { |b| b['PraiaId'] == praia.Id }).to be true
      end
    end

    context 'with legacy filters' do
      it 'filters by status_id' do
        specific_status = create(:status_barraca)
        create(:barraca, StatusBarracaId: specific_status.Id)

        get '/api/v1/barracas', params: { status_id: specific_status.Id }
        expect(response).to have_http_status(:ok).and match_json_schema('barracas')
      end

      it 'returns correct barraca for status filter' do
        specific_status = create(:status_barraca)
        barraca_with_status = create(:barraca, StatusBarracaId: specific_status.Id)

        get '/api/v1/barracas', params: { status_id: specific_status.Id }
        expect(response.parsed_body.first['Id']).to eq(barraca_with_status.Id)
      end

      it 'filters by praia_id' do
        get '/api/v1/barracas', params: { praia_id: praia.Id }
        expect(response).to have_http_status(:ok).and match_json_schema('barracas')
      end

      it 'returns only barracas from specified praia' do
        get '/api/v1/barracas', params: { praia_id: praia.Id }
        expect(response.parsed_body.all? { |b| b['PraiaId'] == praia.Id }).to be true
      end
    end
  end

  describe 'GET /api/v1/barracas/:id' do
    let(:barraca) { create(:barraca) }

    context 'when barraca exists' do
      before { get "/api/v1/barracas/#{barraca.Id}" }

      it 'returns the barraca with valid schema' do
        expect(response).to have_http_status(:ok).and match_json_schema('barraca')
      end

      it 'returns the correct barraca' do
        expect(response.parsed_body['Id']).to eq(barraca.Id)
      end

      it 'includes associations' do
        expect(response.parsed_body).to include(
          'praia', 'status_barraca', 'tipo_area_cobertura', 'tipo_barraca'
        )
      end
    end

    context 'when barraca does not exist' do
      before { get '/api/v1/barracas/999999' }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found).and match_json_schema('error')
      end
    end
  end
end
