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
require 'rails_helper'

RSpec.describe Usuario, type: :model do
  # Create supporting records for validations
  subject(:usuario) do
    described_class.new(
      email: 'test@example.com',
      nome: 'Test User',
      cpf: '12345678901',
      TermoDeUsoAceito: true,
      StatusUsuarioId: status_usuario.Id,
      tipoacessoid: tipo_acesso.Id,
      tipousuarioid: tipo_usuario.Id
    )
  end

  let!(:status_usuario) { StatusUsuario.create!(Id: 1, Status: 'Ativo') }
  let!(:tipo_acesso) { TipoAcesso.create!(Id: 1, Tipo: 'Admin') }
  let!(:tipo_usuario) { TipoUsuario.create!(Id: 1, Tipo: 'Cliente') }

  describe 'associations' do
    it { is_expected.to belong_to(:status_usuario).class_name('StatusUsuario').with_foreign_key('StatusUsuarioId') }
    it { is_expected.to belong_to(:tipo_acesso).class_name('TipoAcesso').with_foreign_key('tipoacessoid') }
    it { is_expected.to belong_to(:tipo_usuario).class_name('TipoUsuario').with_foreign_key('tipousuarioid') }

    it { is_expected.to have_many(:contas).class_name('Conta').with_foreign_key('usuarioid').dependent(:destroy) }

    it {
      expect(usuario).to have_many(:usuario_barracas)
        .class_name('UsuarioBarraca')
        .with_foreign_key('usuarioid')
        .dependent(:destroy)
    }

    it { is_expected.to have_many(:barracas).through(:usuario_barracas) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { expect(usuario).to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid_email').for(:email) }

    it { is_expected.to validate_presence_of(:nome) }
    it { is_expected.to validate_length_of(:nome).is_at_most(255) }

    it { is_expected.to validate_presence_of(:cpf) }

    it 'validates uniqueness of cpf' do
      usuario.save!
      duplicate = usuario.dup
      expect(duplicate).not_to be_valid
    end

    it 'adds error message for duplicate cpf' do
      usuario.save!
      duplicate = usuario.dup
      duplicate.valid?
      expect(duplicate.errors[:cpf]).to include('has already been taken')
    end
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(described_class.table_name).to eq('Usuario')
    end
  end
end
