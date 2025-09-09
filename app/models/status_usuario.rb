class StatusUsuario < ApplicationRecord
  self.table_name = 'StatusUsuario'

  # Associations
  has_many :usuarios, class_name: 'Usuario', foreign_key: 'StatusUsuarioId', dependent: :restrict_with_error
end
