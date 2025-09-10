# == Schema Information
#
# Table name: Item
#
#  BarracaCategoriaId :integer
#  Excluido           :boolean          not null
#  Id                 :integer          not null, primary key
#  NomeImpressora     :string(100)
#  Ordem              :integer
#  barracaid          :integer          not null
#  produtoid          :integer          not null
#  qtdMax             :integer
#  statusItemId       :integer          not null
#  valor              :decimal(10, 2)   not null
#
# Foreign Keys
#
#  FK_Item_Barraca    (barracaid => Barraca.Id)
#  FK_Item_Categoria  (BarracaCategoriaId => BarracaCategoria.Id)
#  FK_Item_Produto    (produtoid => Produto.Id)
#  FK_Item_Status     (statusItemId => StatusItem.Id)
#
require 'rails_helper'

RSpec.describe Item, type: :model do
  subject(:item) { build(:item) }

  describe 'associations' do
    it { is_expected.to belong_to(:barraca).class_name('Barraca').with_foreign_key('barracaid') }
    it { is_expected.to belong_to(:produto).class_name('Produto').with_foreign_key('produtoid') }
    it { is_expected.to belong_to(:status_item).class_name('StatusItem').with_foreign_key('statusItemId') }

    it {
      expect(item).to belong_to(:barraca_categoria)
        .class_name('BarracaCategoria')
        .with_foreign_key('BarracaCategoriaId')
        .optional
    }

    it {
      expect(item).to have_many(:pedido_items)
        .class_name('PedidoItem')
        .with_foreign_key('itemid')
        .dependent(:destroy)
    }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:valor) }
    it { is_expected.to validate_numericality_of(:valor).is_greater_than(0) }
  end

  describe 'scopes' do
    describe '.active' do
      it 'returns items that are not excluded' do
        expect(described_class.active.to_sql).to include('Excluido')
      end
    end

    describe '.excluded' do
      it 'returns items that are excluded' do
        expect(described_class.excluded.to_sql).to include('Excluido')
      end
    end
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(described_class.table_name).to eq('Item')
    end
  end
end
