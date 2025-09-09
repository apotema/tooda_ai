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
