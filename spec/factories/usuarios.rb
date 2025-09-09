FactoryBot.define do
  factory :usuario do
    sequence(:Id) { |n| n }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:nome) { |n| "User #{n}" }
    sequence(:cpf) { |n| n.to_s.rjust(11, '0').to_s }
    TermoDeUsoAceito { true }

    after(:build) do |usuario|
      usuario.StatusUsuarioId ||= create(:status_usuario).Id
      usuario.tipoacessoid ||= create(:tipo_acesso).Id
      usuario.tipousuarioid ||= create(:tipo_usuario).Id
    end
  end
end
