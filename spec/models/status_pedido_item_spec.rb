require 'rails_helper'

RSpec.describe StatusPedidoItem, type: :model do
  describe 'associations' do
    it {
      expect(subject).to have_many(:pedido_items)
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
