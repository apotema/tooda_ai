# == Schema Information
#
# Table name: StatusUsuario
#
#  Id     :integer          not null, primary key
#  Status :string(50)       not null
#
class StatusUsuario < ApplicationRecord
  self.table_name = 'StatusUsuario'

  # Associations
  has_many :usuarios, class_name: 'Usuario', foreign_key: 'StatusUsuarioId', dependent: :restrict_with_error,
                      inverse_of: :status_usuario
end
