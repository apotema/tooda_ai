class TipoAcesso < ApplicationRecord
  self.table_name = 'TipoAcesso'
  
  has_many :usuarios, class_name: 'Usuario', foreign_key: 'tipoacessoid', dependent: :restrict_with_error
end