require 'rails_helper'

RSpec.describe Pedido, type: :model do
  describe 'associations' do
    it { should belong_to(:conta).class_name('Conta').with_foreign_key('contaid') }
    it { should belong_to(:status_pedido).class_name('StatusPedido').with_foreign_key('statuspedidoid') }
    it { should belong_to(:tipo_entrega).class_name('TipoEntrega').with_foreign_key('tipoEntregaId') }
    it { should belong_to(:operador).class_name('Operador').with_foreign_key('operadorId').optional }
    
    it { should have_many(:pedido_items).class_name('PedidoItem').with_foreign_key('pedidoid').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:data) }
    it { should validate_presence_of(:conta) }
    it { should validate_presence_of(:status_pedido) }
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(Pedido.table_name).to eq('Pedido')
    end
  end
end