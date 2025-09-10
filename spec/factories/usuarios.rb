# == Schema Information
#
# Table name: Usuario
#
#  DataInclusao          :datetime         not null
#  DataNascimento        :datetime
#  Id                    :integer          not null, primary key
#  IdentificadorExterno  :string(50)
#  StatusUsuarioId       :integer          not null
#  TermoDeUsoAceito      :boolean          not null
#  TrocaSenha            :boolean          default(FALSE), not null
#  codTelefonePrimario   :string(2)
#  codTelefoneSecundario :string(2)
#  cpf                   :string(15)
#  email                 :string(100)
#  identidade            :string(15)
#  nome                  :string(100)
#  password              :string(50)
#  telefonePrimario      :string(20)
#  telefoneSecundario    :string(20)
#  tipoacessoid          :integer          not null
#  tipousuarioid         :integer          not null
#
# Foreign Keys
#
#  FK_Users_StatusUsuario  (StatusUsuarioId => StatusUsuario.Id)
#  FK_Users_TipoAcesso     (tipoacessoid => TipoAcesso.Id)
#  FK_Users_TipoUsuario    (tipousuarioid => TipoUsuario.Id)
#
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
