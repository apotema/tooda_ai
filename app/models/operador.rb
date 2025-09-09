class Operador < ApplicationRecord
  self.table_name = 'Operador'

  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'BarracaId', inverse_of: :operadors
  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'UsuarioId', inverse_of: false
  belongs_to :tipo_operador, class_name: 'TipoOperador', foreign_key: 'TipoOperadorId', inverse_of: false
  belongs_to :status_operador, class_name: 'StatusOperador', foreign_key: 'StatusOperadorId', inverse_of: false

  has_many :contas, class_name: 'Conta', foreign_key: 'operadorId', dependent: :restrict_with_error,
                    inverse_of: :operador
  has_many :pedidos, class_name: 'Pedido', foreign_key: 'operadorId', dependent: :restrict_with_error,
                     inverse_of: :operador
end
