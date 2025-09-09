require 'rails_helper'

RSpec.describe Conta, type: :model do
  subject(:conta) { build(:conta) }

  describe 'associations' do
    it { is_expected.to belong_to(:barraca).class_name('Barraca').with_foreign_key('barracaid') }
    it { is_expected.to belong_to(:usuario).class_name('Usuario').with_foreign_key('usuarioid') }
    it { is_expected.to belong_to(:status_conta).class_name('StatusConta').with_foreign_key('statuscontaid') }
    it { is_expected.to belong_to(:forma_pagamento).class_name('FormaPagamento').with_foreign_key('formapagamentoid') }
    it { is_expected.to belong_to(:operador).class_name('Operador').with_foreign_key('operadorId').optional }

    it {
      expect(conta).to belong_to(:cartao_credito)
        .class_name('CartaoCredito')
        .with_foreign_key('CartaoCreditoId')
        .optional
    }

    it { is_expected.to have_many(:pedidos).class_name('Pedido').with_foreign_key('contaid').dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:numero) }
    it { is_expected.to validate_presence_of(:data) }
    it { is_expected.to validate_presence_of(:identificadorConta) }
    it { expect(conta).to validate_uniqueness_of(:identificadorConta).case_insensitive }
  end

  describe 'table configuration' do
    it 'uses the correct table name' do
      expect(described_class.table_name).to eq('Conta')
    end
  end

  describe '#total' do
    let!(:item) { create(:item) }
    let!(:closed_conta) do
      create(:conta, :closed,
             valorTaxaServico: 5.00,
             valorTaxaApp: 2.00,
             valorDesconto: 1.00)
    end

    context 'when conta is closed (statuscontaid = 4)' do
      let!(:pedido) { create(:pedido, :completed, conta: closed_conta) }
      let!(:pedido_item) do
        create(:pedido_item,
               pedido: pedido,
               item: item,
               quantidade: 2,
               valor: 10.00)
      end

      context 'with only pedido items' do
        it 'calculates total with items + fees - discount' do
          # Items: 2 * 10.00 = 20.00
          # + Service fee: 5.00
          # + App fee: 2.00
          # - Discount: 1.00
          # = 26.00
          expect(closed_conta.total).to eq(26.00)
        end
      end

      context 'with pedido items and accompaniments' do
        let!(:grupo_acompanhamento) { create(:grupo_acompanhamento, itemId: item.Id) }
        let!(:item_acompanhamento) do
          create(:item_acompanhamento,
                 grupoAcompanhamentoId: grupo_acompanhamento.Id,
                 valor: 3.00)
        end
        let!(:pedido_item_acompanhamento) do
          create(:pedido_item_acompanhamento,
                 pedidoItemid: pedido_item.Id,
                 itemAcompanhamentoid: item_acompanhamento.Id,
                 quantidade: 1,
                 valor: 3.00)
        end

        it 'calculates total with items + accompaniments + fees - discount' do
          # Items: 2 * 10.00 = 20.00
          # Accompaniments: 2 (pedido_item qty) * 1 * 3.00 = 6.00
          # + Service fee: 5.00
          # + App fee: 2.00
          # - Discount: 1.00
          # = 32.00
          expect(closed_conta.total).to eq(32.00)
        end
      end

      context 'with zero fee values' do
        let!(:conta_with_zero_fees) { create(:conta, :closed, :with_zero_fees) }
        let!(:pedido_zero_fees) { create(:pedido, :completed, conta: conta_with_zero_fees) }
        let!(:pedido_item_zero_fees) do
          create(:pedido_item,
                 pedido: pedido_zero_fees,
                 item: item,
                 quantidade: 1,
                 valor: 15.00)
        end

        it 'handles zero values correctly' do
          # Items: 1 * 15.00 = 15.00
          # + Service fee: 0.00
          # + App fee: 0.00
          # - Discount: 0.00
          # = 15.00
          expect(conta_with_zero_fees.total).to eq(15.00)
        end
      end
    end

    context 'when conta is not closed (statuscontaid != 4)' do
      it 'returns 0' do
        expect(subject.total).to eq(0)
      end
    end

    context 'when pedidos are not completed (statuspedidoid != 4)' do
      let!(:incomplete_pedido) { create(:pedido, conta: closed_conta) } # Default is not completed
      let!(:incomplete_pedido_item) do
        create(:pedido_item,
               pedido: incomplete_pedido,
               item: item,
               quantidade: 5,
               valor: 20.00)
      end

      it 'excludes incomplete pedidos from calculation' do
        # Only fees and discount (no pedido items counted)
        # + Service fee: 5.00
        # + App fee: 2.00
        # - Discount: 1.00
        # = 6.00
        expect(closed_conta.total).to eq(6.00)
      end
    end

    context 'when pedido items have invalid status' do
      let!(:cancelled_status) { create(:status_pedido_item, :cancelled) }
      let!(:invalid_pedido) { create(:pedido, :completed, conta: closed_conta) }
      let!(:invalid_pedido_item) do
        create(:pedido_item,
               pedidoid: invalid_pedido.Id,
               itemid: item.Id,
               StatusPedidoItemId: cancelled_status.Id,
               quantidade: 3,
               valor: 25.00)
      end

      it 'excludes invalid pedido items from calculation' do
        # Only fees and discount (no pedido items counted due to invalid status)
        # + Service fee: 5.00
        # + App fee: 2.00
        # - Discount: 1.00
        # = 6.00
        expect(closed_conta.total).to eq(6.00)
      end
    end
  end
end
