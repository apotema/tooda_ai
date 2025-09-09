require 'rails_helper'

RSpec.describe Barraca, type: :model do
  describe 'associations' do
    it { should belong_to(:praia).class_name('Praia').with_foreign_key('PraiaId') }
    it { should belong_to(:status_barraca).class_name('StatusBarraca').with_foreign_key('StatusBarracaId') }
    it { should belong_to(:tipo_area_cobertura).class_name('TipoAreaCobertura').with_foreign_key('TipoAreaCoberturaId') }
    
    it { should have_many(:contas).class_name('Conta').with_foreign_key('barracaid').dependent(:destroy) }
    it { should have_many(:items).class_name('Item').with_foreign_key('barracaid').dependent(:destroy) }
    it { should have_many(:operadors).class_name('Operador').with_foreign_key('BarracaId').dependent(:destroy) }
    it { should have_many(:usuario_barracas).class_name('UsuarioBarraca').with_foreign_key('barracaid').dependent(:destroy) }
    it { should have_many(:usuarios).through(:usuario_barracas) }
  end

  describe 'validations' do
    it { should validate_presence_of(:Nome) }
    it { should validate_length_of(:Nome).is_at_most(255) }
    
    it { should validate_presence_of(:Numero) }
    
    it { should validate_presence_of(:Latitude) }
    it { should validate_numericality_of(:Latitude) }
    
    it { should validate_presence_of(:Longitude) }
    it { should validate_numericality_of(:Longitude) }
    
    it { should validate_numericality_of(:PercentualComissao).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
  end

  describe 'scopes' do
    it 'has a by_praia scope' do
      expect(Barraca).to respond_to(:by_praia)
    end
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(Barraca.table_name).to eq('Barraca')
    end
  end
end