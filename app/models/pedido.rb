# == Schema Information
#
# Table name: Pedido
#
#  Id             :bigint           not null, primary key
#  TaxaEntrega    :decimal(18, 2)
#  contaid        :bigint           not null
#  data           :datetime         not null
#  impresso       :boolean          not null
#  observacao     :string(200)
#  operadorId     :integer
#  statuspedidoid :integer          not null
#  tipoEntregaId  :integer
#  valorDesconto  :decimal(18, 2)
#
# Foreign Keys
#
#  FK_Pedido_Conta        (contaid => Conta.Id)
#  FK_Pedido_Operador     (operadorId => Operador.Id)
#  FK_Pedido_Status       (statuspedidoid => StatusPedido.Id)
#  FK_Pedido_TipoEntrega  (tipoEntregaId => TipoEntrega.Id)
#
class Pedido < ApplicationRecord
  self.table_name = 'Pedido'

  # Associations
  belongs_to :conta, class_name: 'Conta', foreign_key: 'contaid', inverse_of: :pedidos
  belongs_to :status_pedido, class_name: 'StatusPedido', foreign_key: 'statuspedidoid', inverse_of: :pedidos
  belongs_to :tipo_entrega, class_name: 'TipoEntrega', foreign_key: 'tipoEntregaId', inverse_of: :pedidos
  belongs_to :operador, class_name: 'Operador', foreign_key: 'operadorId', optional: true, inverse_of: :pedidos

  has_many :pedido_items, class_name: 'PedidoItem', foreign_key: 'pedidoid', dependent: :destroy, inverse_of: :pedido

  # Validations
  validates :data, presence: true
end
