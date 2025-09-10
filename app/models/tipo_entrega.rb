# == Schema Information
#
# Table name: TipoEntrega
#
#  Id   :integer          not null, primary key
#  Tipo :string(20)       not null
#
class TipoEntrega < ApplicationRecord
  self.table_name = 'TipoEntrega'

  has_many :pedidos, class_name: 'Pedido', foreign_key: 'tipoEntregaId', dependent: :restrict_with_error,
                     inverse_of: :tipo_entrega
end
