FactoryBot.define do
  factory :pedido do
    sequence(:Id) { |n| n }
    data { Time.current }
    impresso { false }

    after(:build) do |pedido|
      pedido.contaid ||= create(:conta).Id
      pedido.statuspedidoid ||= create(:status_pedido).Id
      pedido.tipoEntregaId ||= create(:tipo_entrega).Id
    end

    trait :completed do
      after(:build) do |pedido|
        pedido.statuspedidoid = create(:status_pedido, :completed).Id
      end
    end
  end
end