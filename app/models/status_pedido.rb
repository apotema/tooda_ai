# == Schema Information
#
# Table name: StatusPedido
#
#  Id     :integer          not null, primary key
#  Status :string(50)       not null
#
class StatusPedido < ApplicationRecord
  self.table_name = 'StatusPedido'

  has_many :pedidos, class_name: 'Pedido', foreign_key: 'statuspedidoid', dependent: :restrict_with_error,
                     inverse_of: :status_pedido
end
