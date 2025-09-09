require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it { should belong_to(:barraca).class_name('Barraca').with_foreign_key('barracaid') }
    it { should belong_to(:produto).class_name('Produto').with_foreign_key('produtoid') }
    it { should belong_to(:status_item).class_name('StatusItem').with_foreign_key('statusItemId') }
    it { should belong_to(:barraca_categoria).class_name('BarracaCategoria').with_foreign_key('BarracaCategoriaId').optional }
    
    it { should have_many(:pedido_items).class_name('PedidoItem').with_foreign_key('itemid').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:valor) }
    it { should validate_numericality_of(:valor).is_greater_than(0) }
    it { should validate_presence_of(:barraca) }
    it { should validate_presence_of(:produto) }
  end

  describe 'scopes' do
    describe '.active' do
      it 'returns items that are not excluded' do
        expect(Item.active.to_sql).to include('Excluido')
      end
    end

    describe '.excluded' do
      it 'returns items that are excluded' do
        expect(Item.excluded.to_sql).to include('Excluido')
      end
    end
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(Item.table_name).to eq('Item')
    end
  end
end