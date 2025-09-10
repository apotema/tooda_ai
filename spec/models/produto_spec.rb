# == Schema Information
#
# Table name: Produto
#
#  BarracaId     :integer
#  Excluido      :boolean          not null
#  Id            :integer          not null, primary key
#  Ordem         :integer          not null
#  QtdItens      :integer          default(1), not null
#  ativo         :boolean          not null
#  cest          :string(20)
#  cfop          :string(20)
#  cofins        :string(20)
#  csosn         :string(20)
#  detalhe       :string(300)
#  icms          :string(20)
#  ipi           :string(20)
#  ncm           :string(20)
#  nome          :string(50)       not null
#  origemIcms    :string(20)
#  pis           :string(20)
#  tipoProdutoid :integer          not null
#
# Foreign Keys
#
#  FK_Item_TipoProduto  (tipoProdutoid => TipoProduto.Id)
#
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
      it 'includes ativo condition in SQL' do
        expect(described_class.active.to_sql).to include('ativo')
      end

      it 'includes Excluido condition in SQL' do
        expect(described_class.active.to_sql).to include('Excluido')
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
