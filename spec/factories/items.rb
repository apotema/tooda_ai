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