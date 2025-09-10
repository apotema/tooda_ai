# == Schema Information
#
# Table name: PedidoItemAcompanhamento
#
#  Id                   :bigint           not null, primary key
#  NomeAcompanhamento   :string(50)
#  itemAcompanhamentoid :integer          not null
#  observacao           :string(200)
#  pedidoItemid         :bigint           not null
#  quantidade           :integer          not null
#  valor                :decimal(10, 2)   not null
#
# Foreign Keys
#
#  FK_PedidoItemAcompanhamento_Item        (itemAcompanhamentoid => ItemAcompanhamento.Id)
#  FK_PedidoItemAcompanhamento_PedidoItem  (pedidoItemid => PedidoItem.Id)
#
class PedidoItemAcompanhamento < ApplicationRecord
  self.table_name = 'PedidoItemAcompanhamento'

  belongs_to :pedido_item, class_name: 'PedidoItem', foreign_key: 'pedidoItemid',
                           inverse_of: :pedido_item_acompanhamentos
  belongs_to :item_acompanhamento, class_name: 'ItemAcompanhamento', foreign_key: 'itemAcompanhamentoid',
                                   inverse_of: :pedido_item_acompanhamentos

  validates :quantidade, presence: true, numericality: { greater_than: 0 }
  validates :valor, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
