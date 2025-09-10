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
FactoryBot.define do
  factory :item do
    sequence(:Id) { |n| n }
    valor { 10.00 }
    Excluido { false }

    after(:build) do |item|
      item.barracaid ||= create(:barraca).Id
      item.produtoid ||= create(:produto).Id
      item.statusItemId ||= create(:status_item).Id
    end
  end
end
