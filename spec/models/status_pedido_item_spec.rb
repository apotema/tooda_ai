require 'rails_helper'

RSpec.describe StatusPedidoItem, type: :model do
  subject(:status_pedido_item) { build(:status_pedido_item) }

  describe 'associations' do
    it {
      expect(status_pedido_item).to have_many(:pedido_items)
        .class_name('PedidoItem')
        .with_foreign_key('StatusPedidoItemId')
        .dependent(:restrict_with_error)
    }
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(described_class.table_name).to eq('StatusPedidoItem')
    end
  end
end
