require 'rails_helper'

RSpec.describe Pedido, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:conta).class_name('Conta').with_foreign_key('contaid') }
    it { is_expected.to belong_to(:status_pedido).class_name('StatusPedido').with_foreign_key('statuspedidoid') }
    it { is_expected.to belong_to(:tipo_entrega).class_name('TipoEntrega').with_foreign_key('tipoEntregaId') }
    it { is_expected.to belong_to(:operador).class_name('Operador').with_foreign_key('operadorId').optional }

    it {
      expect(subject).to have_many(:pedido_items)
        .class_name('PedidoItem')
        .with_foreign_key('pedidoid')
        .dependent(:destroy)
    }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:data) }
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(described_class.table_name).to eq('Pedido')
    end
  end
end
