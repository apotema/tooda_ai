FactoryBot.define do
  factory :produto do
    sequence(:Id) { |n| n }
    sequence(:nome) { |n| "Produto #{n}" }
    ativo { true }
    Ordem { 1 }
    Excluido { false }

    after(:build) do |produto|
      produto.tipoProdutoid ||= create(:tipo_produto).Id
    end
  end
end