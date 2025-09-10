require 'swagger_helper'

RSpec.describe 'api/v1/barracas', type: :request do
  path '/api/v1/barracas' do
    get('list barracas') do
      tags 'Barracas'
      description 'Retrieve a paginated list of barracas with optional filtering and searching'
      produces 'application/json'
      
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Number of items per page (default: 25)'
      parameter name: :status_id, in: :query, type: :integer, required: false, description: 'Filter by status barraca ID'
      parameter name: :praia_id, in: :query, type: :integer, required: false, description: 'Filter by praia ID'
      parameter name: 'q[Nome_cont]', in: :query, type: :string, required: false, description: 'Search barracas by name containing text'
      parameter name: 'q[Nome_start]', in: :query, type: :string, required: false, description: 'Search barracas by name starting with text'
      parameter name: 'q[s]', in: :query, type: :string, required: false, description: 'Sort criteria (e.g., "Nome asc", "Nome desc")'

      response(200, 'successful') do
        header 'X-Current-Page', schema: { type: :string }, description: 'Current page number'
        header 'X-Total-Pages', schema: { type: :string }, description: 'Total number of pages'
        header 'X-Total-Count', schema: { type: :string }, description: 'Total number of barracas'
        header 'X-Per-Page', schema: { type: :string }, description: 'Number of items per page'

        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   Id: { type: :integer },
                   Nome: { type: :string },
                   Numero: { type: [:string, :null] },
                   Licenca: { type: [:string, :null] },
                   CpfCnpj: { type: [:string, :null] },
                   ChavePix: { type: [:string, :null] },
                   Latitude: { type: [:string, :null] },
                   Longitude: { type: [:string, :null] },
                   Ordem: { type: :integer },
                   PercentualComissao: { type: [:string, :number, :null] },
                   PercentualComissaoCartao: { type: [:string, :number, :null] },
                   RaioEntrega: { type: [:integer, :null] },
                   TaxaEntrega: { type: [:string, :number, :null] },
                   TaxaServico: { type: [:string, :number, :null] },
                   UrlQrCode: { type: [:string, :null] },
                   UrlQrCodeBackup: { type: [:string, :null] },
                   DataInclusao: { type: [:string, :null] },
                   PraiaId: { type: [:integer, :null] },
                   StatusBarracaId: { type: :integer },
                   TipoAreaCoberturaId: { type: :integer },
                   TipoBarracaId: { type: :integer },
                   praia: {
                     type: [:object, :null],
                     properties: {
                       Id: { type: :integer },
                       Nome: { type: :string }
                     }
                   },
                   status_barraca: {
                     type: [:object, :null],
                     properties: {
                       Id: { type: :integer },
                       Status: { type: :string }
                     }
                   },
                   tipo_area_cobertura: {
                     type: [:object, :null],
                     properties: {
                       Id: { type: :integer },
                       Tipo: { type: :string }
                     }
                   },
                   tipo_barraca: {
                     type: [:object, :null],
                     properties: {
                       Id: { type: :integer },
                       Tipo: { type: :string }
                     }
                   }
                 },
                 required: ['Id', 'Nome', 'Ordem', 'StatusBarracaId', 'TipoAreaCoberturaId', 'TipoBarracaId']
               }

        let(:praia) { create(:praia) }

        context 'without parameters' do
          before do
            create(:barraca, Nome: 'Barraca Sol', PraiaId: praia.Id)
            create(:barraca, Nome: 'Barraca Mar', PraiaId: praia.Id)
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data).to be_an(Array)
            expect(data.size).to be >= 2
          end
        end

        context 'with pagination' do
          let(:page) { 1 }
          let(:per_page) { 10 }

          before do
            15.times { |i| create(:barraca, Nome: "Barraca #{i}") }
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data).to be_an(Array)
            expect(data.size).to eq(10)
            expect(response.headers['X-Current-Page']).to eq('1')
            expect(response.headers['X-Per-Page']).to eq('10')
          end
        end

        context 'with search filters' do
          let(:'q[Nome_cont]') { 'Sol' }

          before do
            create(:barraca, Nome: 'Barraca Sol')
            create(:barraca, Nome: 'Barraca Mar')
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data).to be_an(Array)
            expect(data.first['Nome']).to include('Sol')
          end
        end
      end
    end
  end

  path '/api/v1/barracas/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Barraca ID'

    get('show barraca') do
      tags 'Barracas'
      description 'Retrieve a specific barraca by ID'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 Id: { type: :integer },
                 Nome: { type: :string },
                 Numero: { type: [:string, :null] },
                 Licenca: { type: [:string, :null] },
                 CpfCnpj: { type: [:string, :null] },
                 ChavePix: { type: [:string, :null] },
                 Latitude: { type: [:string, :null] },
                 Longitude: { type: [:string, :null] },
                 Ordem: { type: :integer },
                 PercentualComissao: { type: [:string, :number, :null] },
                 PercentualComissaoCartao: { type: [:string, :number, :null] },
                 RaioEntrega: { type: [:integer, :null] },
                 TaxaEntrega: { type: [:string, :number, :null] },
                 TaxaServico: { type: [:string, :number, :null] },
                 UrlQrCode: { type: [:string, :null] },
                 UrlQrCodeBackup: { type: [:string, :null] },
                 DataInclusao: { type: [:string, :null] },
                 PraiaId: { type: [:integer, :null] },
                 StatusBarracaId: { type: :integer },
                 TipoAreaCoberturaId: { type: :integer },
                 TipoBarracaId: { type: :integer },
                 praia: {
                   type: [:object, :null],
                   properties: {
                     Id: { type: :integer },
                     Nome: { type: :string }
                   }
                 },
                 status_barraca: {
                   type: [:object, :null],
                   properties: {
                     Id: { type: :integer },
                     Status: { type: :string }
                   }
                 },
                 tipo_area_cobertura: {
                   type: [:object, :null],
                   properties: {
                     Id: { type: :integer },
                     Tipo: { type: :string }
                   }
                 },
                 tipo_barraca: {
                   type: [:object, :null],
                   properties: {
                     Id: { type: :integer },
                     Tipo: { type: :string }
                   }
                 }
               },
               required: ['Id', 'Nome', 'Ordem', 'StatusBarracaId', 'TipoAreaCoberturaId', 'TipoBarracaId']

        let(:barraca) { create(:barraca) }
        let(:id) { barraca.Id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['Id']).to eq(barraca.Id)
          expect(data['Nome']).to eq(barraca.Nome)
        end
      end

      response(404, 'not found') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               },
               required: ['error']

        let(:id) { 999999 }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Barraca not found')
        end
      end
    end
  end
end