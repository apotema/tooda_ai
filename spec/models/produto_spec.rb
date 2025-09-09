require 'rails_helper'

RSpec.describe Produto, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:tipo_produto).class_name('TipoProduto').with_foreign_key('tipoProdutoid') }
    it { is_expected.to belong_to(:barraca).class_name('Barraca').with_foreign_key('BarracaId').optional }

    it { is_expected.to have_many(:items).class_name('Item').with_foreign_key('produtoid').dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:nome) }
    it { is_expected.to validate_length_of(:nome).is_at_most(255) }
  end

  describe 'scopes' do
    describe '.active' do
      it 'returns products that are active and not excluded' do
        scope_sql = described_class.active.to_sql
        expect(scope_sql).to include('ativo')
        expect(scope_sql).to include('Excluido')
      end
    end

    describe '.inactive' do
      it 'returns products that are inactive' do
        expect(described_class.inactive.to_sql).to include('ativo')
      end
    end

    describe '.excluded' do
      it 'returns products that are excluded' do
        expect(described_class.excluded.to_sql).to include('Excluido')
      end
    end
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(described_class.table_name).to eq('Produto')
    end
  end
end
