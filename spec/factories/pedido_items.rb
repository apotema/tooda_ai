# == Schema Information
#
# Table name: PedidoItem
#
#  Id                 :bigint           not null, primary key
#  NomeProduto        :string(50)
#  StatusPedidoItemId :integer          not null
#  itemid             :integer          not null
#  observacao         :string(200)
#  pedidoid           :bigint           not null
#  quantidade         :integer          not null
#  valor              :decimal(10, 2)   not null
#
# Foreign Keys
#
#  FK_PedidoItem_Item               (itemid => Item.Id)
#  FK_PedidoItem_Pedido             (pedidoid => Pedido.Id)
#  FK_PedidoItem_[StatusPedidoItem  (StatusPedidoItemId => StatusPedidoItem.Id)
#
FactoryBot.define do
  factory :pedido_item do
    sequence(:Id) { |n| n }
    quantidade { 1 }
    valor { 10.00 }

    after(:build) do |pedido_item|
      pedido_item.pedidoid ||= create(:pedido).Id
      pedido_item.itemid ||= create(:item).Id
      pedido_item.StatusPedidoItemId ||= create(:status_pedido_item, :confirmed).Id
    end
  end
end
