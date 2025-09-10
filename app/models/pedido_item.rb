# == Schema Information
#
# Table name: PedidoItem
#
#  Id                 :bigint           not null, primary key
#  NomeProduto        :string(50)
#  StatusPedidoItemId :integer          not null
#  itemid             :integer          not null
#  observacao         :string(200)
#  pedidoid           :bigint           not null
#  quantidade         :integer          not null
#  valor              :decimal(10, 2)   not null
#
# Foreign Keys
#
#  FK_PedidoItem_Item               (itemid => Item.Id)
#  FK_PedidoItem_Pedido             (pedidoid => Pedido.Id)
#  FK_PedidoItem_[StatusPedidoItem  (StatusPedidoItemId => StatusPedidoItem.Id)
#
class PedidoItem < ApplicationRecord
  self.table_name = 'PedidoItem'

  belongs_to :pedido, class_name: 'Pedido', foreign_key: 'pedidoid', inverse_of: :pedido_items
  belongs_to :item, class_name: 'Item', foreign_key: 'itemid', inverse_of: :pedido_items
  belongs_to :status_pedido_item, class_name: 'StatusPedidoItem', foreign_key: 'StatusPedidoItemId',
                                  inverse_of: :pedido_items

  has_many :pedido_item_acompanhamentos, class_name: 'PedidoItemAcompanhamento', foreign_key: 'pedidoItemid',
                                         dependent: :destroy, inverse_of: :pedido_item

  validates :quantidade, presence: true, numericality: { greater_than: 0 }
  validates :valor, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
