FactoryBot.define do
  factory :status_conta do
    sequence(:Id) { |n| n }
    Status { 'Aberta' }

    trait :aberta do
      Id { 1 }
      Status { 'Aberta' }
    end

    trait :fechada do
      # Use find_or_create to avoid duplicates
      to_create { |instance| StatusConta.find_or_create_by(Id: 4) { |sc| sc.Status = 'Fechada' } }
      Id { 4 }
      Status { 'Fechada' }
    end
  end
end