class TipoBarraca < ApplicationRecord
  self.table_name = 'TipoBarraca'

  has_many :barracas, class_name: 'Barraca', foreign_key: 'TipoBarracaId', dependent: :restrict_with_error
end
