class TipoProduto < ApplicationRecord
  self.table_name = 'TipoProduto'

  has_many :produtos, class_name: 'Produto', foreign_key: 'tipoProdutoid', dependent: :restrict_with_error
end
