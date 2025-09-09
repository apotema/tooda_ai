require 'rails_helper'

RSpec.describe Conta, type: :model do
  # Create supporting records for validations
  let!(:status_usuario) { StatusUsuario.create!(Id: 1, Status: 'Ativo') }
  let!(:tipo_acesso) { TipoAcesso.create!(Id: 1, Tipo: 'Admin') }
  let!(:tipo_usuario) { TipoUsuario.create!(Id: 1, Tipo: 'Cliente') }
  let!(:praia) { Praia.create!(Id: 1, Nome: 'Praia Test', Cidade: 'Recife', Uf: 'PE') }
  let!(:status_barraca) { StatusBarraca.create!(Id: 1, Status: 'Ativo') }
  let!(:tipo_area_cobertura) { TipoAreaCobertura.create!(Id: 1, Tipo: 'Coberto') }
  let!(:tipo_barraca) { TipoBarraca.create!(Id: 1, Tipo: 'Normal') }
  let!(:status_conta) { StatusConta.create!(Id: 1, Status: 'Aberta') }
  let!(:forma_pagamento) { FormaPagamento.create!(Id: 1, Tipo: 'Dinheiro', ativo: true, Codigo: 'DIN') }
  
  let!(:usuario) { Usuario.create!(
    Id: 1, email: 'test@example.com', nome: 'Test User', cpf: '12345678901',
    TermoDeUsoAceito: true, StatusUsuarioId: status_usuario.Id,
    tipoacessoid: tipo_acesso.Id, tipousuarioid: tipo_usuario.Id
  )}
  
  let!(:barraca) { Barraca.create!(
    Id: 1, Nome: 'Barraca Test', Numero: '1', Latitude: -23.5, Longitude: -46.6,
    PraiaId: praia.Id, StatusBarracaId: status_barraca.Id, 
    TipoAreaCoberturaId: tipo_area_cobertura.Id, PercentualComissao: 10.0, 
    Ordem: 1, TipoBarracaId: tipo_barraca.Id, PercentualComissaoCartao: 5.0,
    DataInclusao: Time.current
  )}
  
  subject do
    Conta.new(
      numero: 'C001',
      data: Time.current,
      identificadorConta: 'CONTA_UNIQUE_001',
      barracaid: barraca.Id,
      usuarioid: usuario.Id,
      statuscontaid: status_conta.Id,
      formapagamentoid: forma_pagamento.Id,
      valorTaxaServico: 2.50,
      valorTaxaApp: 1.00,
      valorDesconto: 0.00
    )
  end
  describe 'associations' do
    it { should belong_to(:barraca).class_name('Barraca').with_foreign_key('barracaid') }
    it { should belong_to(:usuario).class_name('Usuario').with_foreign_key('usuarioid') }
    it { should belong_to(:status_conta).class_name('StatusConta').with_foreign_key('statuscontaid') }
    it { should belong_to(:forma_pagamento).class_name('FormaPagamento').with_foreign_key('formapagamentoid') }
    it { should belong_to(:operador).class_name('Operador').with_foreign_key('operadorId').optional }
    it { should belong_to(:cartao_credito).class_name('CartaoCredito').with_foreign_key('CartaoCreditoId').optional }
    
    it { should have_many(:pedidos).class_name('Pedido').with_foreign_key('contaid').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:numero) }
    it { should validate_presence_of(:data) }
    it { should validate_presence_of(:identificadorConta) }
    it { expect(subject).to validate_uniqueness_of(:identificadorConta).case_insensitive }
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(Conta.table_name).to eq('Conta')
    end
  end
end