# == Schema Information
#
# Table name: StatusPedidoItem
#
#  Id     :integer          not null, primary key
#  Status :string(50)       not null
#
class StatusPedidoItem < ApplicationRecord
  self.table_name = 'StatusPedidoItem'

  has_many :pedido_items, class_name: 'PedidoItem', foreign_key: 'StatusPedidoItemId', dependent: :restrict_with_error,
                          inverse_of: :status_pedido_item
end
