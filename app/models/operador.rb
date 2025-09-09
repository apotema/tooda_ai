class Operador < ApplicationRecord
  self.table_name = 'Operador'

  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'BarracaId'
  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'UsuarioId'
  belongs_to :tipo_operador, class_name: 'TipoOperador', foreign_key: 'TipoOperadorId'
  belongs_to :status_operador, class_name: 'StatusOperador', foreign_key: 'StatusOperadorId'

  has_many :contas, class_name: 'Conta', foreign_key: 'operadorId', dependent: :restrict_with_error
  has_many :pedidos, class_name: 'Pedido', foreign_key: 'operadorId', dependent: :restrict_with_error
end
