class StatusBarraca < ApplicationRecord
  self.table_name = 'StatusBarraca'

  has_many :barracas, class_name: 'Barraca', foreign_key: 'StatusBarracaId', dependent: :restrict_with_error
end
