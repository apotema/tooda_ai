FactoryBot.define do
  factory :conta do
    sequence(:numero) { |n| "C#{n.to_s.rjust(3, '0')}" }
    data { Time.current }
    sequence(:identificadorConta) { |n| "CONTA_#{n}" }
    valorTaxaServico { 2.50 }
    valorTaxaApp { 1.00 }
    valorDesconto { 0.00 }

    after(:build) do |conta|
      conta.barracaid ||= create(:barraca).Id
      conta.usuarioid ||= create(:usuario).Id
      conta.statuscontaid ||= create(:status_conta).Id
      conta.formapagamentoid ||= create(:forma_pagamento).Id
    end

    trait :closed do
      after(:build) do |conta|
        conta.statuscontaid = create(:status_conta, :fechada).Id
      end
    end

    trait :open do
      after(:build) do |conta|
        conta.statuscontaid = create(:status_conta, :aberta).Id
      end
    end

    trait :with_zero_fees do
      valorTaxaServico { 0.00 }
      valorTaxaApp { 0.00 }
      valorDesconto { 0.00 }
    end

    trait :with_high_fees do
      valorTaxaServico { 10.00 }
      valorTaxaApp { 5.00 }
      valorDesconto { 2.00 }
    end
  end
end