FactoryBot.define do
  factory :praia do
    sequence(:Id) { |n| n }
    sequence(:Nome) { |n| "Praia #{n}" }
    Cidade { 'Recife' }
    Uf { 'PE' }
  end
end
