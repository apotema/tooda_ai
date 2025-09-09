FactoryBot.define do
  factory :forma_pagamento do
    sequence(:Id) { |n| n }
    Tipo { 'Dinheiro' }
    ativo { true }
    Codigo { 'DIN' }
  end
end
