require 'rails_helper'

RSpec.describe Barraca, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:praia).class_name('Praia').with_foreign_key('PraiaId') }
    it { is_expected.to belong_to(:status_barraca).class_name('StatusBarraca').with_foreign_key('StatusBarracaId') }

    it {
      expect(subject).to belong_to(:tipo_area_cobertura).class_name('TipoAreaCobertura').with_foreign_key('TipoAreaCoberturaId')
    }

    it { is_expected.to have_many(:contas).class_name('Conta').with_foreign_key('barracaid').dependent(:destroy) }
    it { is_expected.to have_many(:items).class_name('Item').with_foreign_key('barracaid').dependent(:destroy) }
    it { is_expected.to have_many(:operadors).class_name('Operador').with_foreign_key('BarracaId').dependent(:destroy) }

    it {
      expect(subject).to have_many(:usuario_barracas).class_name('UsuarioBarraca').with_foreign_key('barracaid').dependent(:destroy)
    }

    it { is_expected.to have_many(:usuarios).through(:usuario_barracas) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:Nome) }
    it { is_expected.to validate_length_of(:Nome).is_at_most(255) }

    it { is_expected.to validate_presence_of(:Numero) }

    it { is_expected.to validate_presence_of(:Latitude) }
    it { is_expected.to validate_numericality_of(:Latitude) }

    it { is_expected.to validate_presence_of(:Longitude) }
    it { is_expected.to validate_numericality_of(:Longitude) }

    it {
      expect(subject).to validate_numericality_of(:PercentualComissao).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100)
    }
  end

  describe 'scopes' do
    it 'has a by_praia scope' do
      expect(described_class).to respond_to(:by_praia)
    end
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(described_class.table_name).to eq('Barraca')
    end
  end
end
