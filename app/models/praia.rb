class Praia < ApplicationRecord
  self.table_name = 'Praia'

  has_many :barracas, class_name: 'Barraca', foreign_key: 'PraiaId', dependent: :restrict_with_error
end
