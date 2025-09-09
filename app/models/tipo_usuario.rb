class TipoUsuario < ApplicationRecord
  self.table_name = 'TipoUsuario'

  has_many :usuarios, class_name: 'Usuario', foreign_key: 'tipousuarioid', dependent: :restrict_with_error,
                      inverse_of: :tipo_usuario
end
