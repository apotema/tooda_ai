# == Schema Information
#
# Table name: Conta
#
#  CartaoCreditoId    :bigint
#  Id                 :bigint           not null, primary key
#  UrlNotaFiscal      :string(2000)
#  barracaid          :integer          not null
#  contaPendurada     :boolean          default(FALSE), not null
#  data               :datetime         not null
#  dataFechamento     :datetime
#  formapagamentoid   :integer
#  identificadorConta :string(50)
#  latitude           :decimal(10, 7)
#  longitude          :decimal(10, 7)
#  numero             :bigint           not null
#  numeroMesa         :varchar(200)
#  operadorId         :integer
#  removeTaxaServico  :boolean          default(FALSE), not null
#  statuscontaid      :integer          not null
#  usuarioid          :integer
#  valorDesconto      :decimal(18, 2)   not null
#  valorTaxaApp       :decimal(18, 2)   not null
#  valorTaxaServico   :decimal(18, 2)   not null
#
# Indexes
#
#  IDX_BARRACAID                                 (barracaid)
#  IDX_STATUS_BARRACAID                          (barracaid,statuscontaid)
#  IX_Conta_IdentificadorConta_Status_BarracaId  (identificadorConta,barracaid,statuscontaid)
#
# Foreign Keys
#
#  FK_Conta_Barraca         (barracaid => Barraca.Id)
#  FK_Conta_CartaoCredito   (CartaoCreditoId => CartaoCredito.Id)
#  FK_Conta_FormaPagamento  (formapagamentoid => FormaPagamento.Id)
#  FK_Conta_Operador        (operadorId => Operador.Id)
#  FK_Conta_Status          (statuscontaid => StatusConta.Id)
#  FK_Conta_Usuario         (usuarioid => Usuario.Id)
#
class Conta < ApplicationRecord
  self.table_name = 'Conta'

  # Associations
  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'barracaid', inverse_of: :contas
  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'usuarioid', inverse_of: :contas
  belongs_to :status_conta, class_name: 'StatusConta', foreign_key: 'statuscontaid', inverse_of: false
  belongs_to :forma_pagamento, class_name: 'FormaPagamento', foreign_key: 'formapagamentoid', inverse_of: :contas
  belongs_to :operador, class_name: 'Operador', foreign_key: 'operadorId', optional: true, inverse_of: false
  belongs_to :cartao_credito, class_name: 'CartaoCredito', foreign_key: 'CartaoCreditoId', optional: true,
                              inverse_of: :contas

  has_many :pedidos, class_name: 'Pedido', foreign_key: 'contaid', dependent: :destroy, inverse_of: :conta

  # Validations
  validates :numero, presence: true
  validates :data, presence: true
  validates :identificadorConta, presence: true, uniqueness: true

  # Calculate total value based on pedidos, items, and fees
  def total
    return 0 unless statuscontaid == 4 # Only closed accounts

    calculate_items_total + calculate_accompaniments_total + calculate_fees
  end

  private

  def calculate_items_total
    valid_pedidos
      .joins(:pedido_items)
      .where(pedido_items: { StatusPedidoItemId: [1, 2, 4] })
      .sum('pedido_items.quantidade * pedido_items.valor')
  end

  def calculate_accompaniments_total
    valid_pedidos
      .joins(pedido_items: :pedido_item_acompanhamentos)
      .where(pedido_items: { StatusPedidoItemId: [1, 2, 4] })
      .sum('pedido_items.quantidade * PedidoItemAcompanhamento.quantidade * ' \
           'PedidoItemAcompanhamento.valor')
  rescue ActiveRecord::StatementInvalid
    0
  end

  def calculate_fees
    (valorTaxaServico || 0) + (valorTaxaApp || 0) - (valorDesconto || 0)
  end

  def valid_pedidos
    pedidos.where(statuspedidoid: 4)
  end
end
