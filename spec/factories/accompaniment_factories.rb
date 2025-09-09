FactoryBot.define do
  factory :grupo_acompanhamento do
    sequence(:Id) { |n| n }
    nome { 'Acompanhamentos' }
    obrigatorio { false }
    qtdMin { 0 }
    qtdMax { 5 }

    after(:build) do |grupo|
      grupo.itemId ||= create(:item).Id
    end
  end

  factory :item_acompanhamento do
    sequence(:Id) { |n| n }
    sequence(:nome) { |n| "Acompanhamento #{n}" }
    valor { 3.00 }

    after(:build) do |item_acomp|
      item_acomp.grupoAcompanhamentoId ||= create(:grupo_acompanhamento).Id
      item_acomp.statusItemId ||= create(:status_item).Id
    end
  end

  factory :pedido_item_acompanhamento do
    quantidade { 1 }
    valor { 3.00 }

    after(:build) do |pia|
      pia.pedidoItemid ||= create(:pedido_item).Id
      pia.itemAcompanhamentoid ||= create(:item_acompanhamento).Id
    end
  end
end