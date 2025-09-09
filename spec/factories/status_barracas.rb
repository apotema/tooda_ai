FactoryBot.define do
  factory :status_barraca do
    sequence(:Id) { |n| n }
    Status { 'Ativo' }
  end
end
