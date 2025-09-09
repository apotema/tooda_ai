require 'rails_helper'

RSpec.describe StatusPedidoItem, type: :model do
  describe 'associations' do
    it { should have_many(:pedido_items).class_name('PedidoItem').with_foreign_key('StatusPedidoItemId').dependent(:restrict_with_error) }
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(StatusPedidoItem.table_name).to eq('StatusPedidoItem')
    end
  end
end