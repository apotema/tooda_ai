# == Schema Information
#
# Table name: Operador
#
#  BarracaId             :integer          not null
#  DataInclusao          :datetime         not null
#  Id                    :integer          not null, primary key
#  IdentificadorOperador :string(50)       not null
#  StatusOperadorId      :integer          not null
#  TipoOperadorId        :integer          not null
#  UsuarioId             :integer
#  email                 :string(100)
#  nome                  :string(100)      not null
#
# Foreign Keys
#
#  FK_Operador_Barraca          (BarracaId => Barraca.Id)
#  FK_Operador_StatusOperador   (StatusOperadorId => StatusOperador.Id)
#  FK_Operador_TipoOperador     (TipoOperadorId => TipoOperador.Id)
#  FK_Operador_UsuarioOperador  (UsuarioId => Operador.Id)
#
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
