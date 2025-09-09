class BarracaCategoria < ApplicationRecord
  self.table_name = 'BarracaCategoria'

  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'BarracaId', inverse_of: false

  has_many :items, class_name: 'Item', foreign_key: 'BarracaCategoriaId', dependent: :restrict_with_error,
                   inverse_of: :barraca_categoria
end
