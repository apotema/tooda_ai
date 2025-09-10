# == Schema Information
#
# Table name: ItemAcompanhamento
#
#  Id                    :integer          not null, primary key
#  detalhe               :string(200)
#  grupoAcompanhamentoId :integer          not null
#  nome                  :string(50)       not null
#  statusItemId          :integer          not null
#  valor                 :decimal(10, 2)   not null
#
# Foreign Keys
#
#  FK_ItemAcompanhamento_Grupo   (grupoAcompanhamentoId => GrupoAcompanhamento.Id)
#  FK_ItemAcompanhamento_Status  (statusItemId => StatusItem.Id)
#
class ItemAcompanhamento < ApplicationRecord
  self.table_name = 'ItemAcompanhamento'

  belongs_to :grupo_acompanhamento, class_name: 'GrupoAcompanhamento', foreign_key: 'grupoAcompanhamentoId',
                                    inverse_of: :item_acompanhamentos
  has_many :pedido_item_acompanhamentos, class_name: 'PedidoItemAcompanhamento', foreign_key: 'itemAcompanhamentoid',
                                         dependent: :restrict_with_error, inverse_of: :item_acompanhamento
end
