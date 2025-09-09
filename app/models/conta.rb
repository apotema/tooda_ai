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

    # Get valid pedidos
    valid_pedidos = pedidos.where(statuspedidoid: 4)

    # Sum of pedido items with valid status
    items_total = valid_pedidos
                  .joins(:pedido_items)
                  .where(pedido_items: { StatusPedidoItemId: [1, 2, 4] })
                  .sum('pedido_items.quantidade * pedido_items.valor')

    # Sum of pedido item accompaniments (handle case where no accompaniments exist)
    accompaniments_total = 0
    begin
      accompaniments_total = valid_pedidos
                             .joins(pedido_items: :pedido_item_acompanhamentos)
                             .where(pedido_items: { StatusPedidoItemId: [1, 2, 4] })
                             .sum('pedido_items.quantidade * PedidoItemAcompanhamento.quantidade * ' \
                                  'PedidoItemAcompanhamento.valor')
    rescue ActiveRecord::StatementInvalid
      # If there are no accompaniments or table doesn't exist, set to 0
      accompaniments_total = 0
    end

    # Calculate final total with fees and discount
    items_total +
      accompaniments_total +
      (valorTaxaServico || 0) +
      (valorTaxaApp || 0) -
      (valorDesconto || 0)
  end
end
