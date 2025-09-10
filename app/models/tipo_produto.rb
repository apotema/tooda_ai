# == Schema Information
#
# Table name: TipoProduto
#
#  Id   :integer          not null, primary key
#  Tipo :string(20)       not null
#
class TipoProduto < ApplicationRecord
  self.table_name = 'TipoProduto'

  has_many :produtos, class_name: 'Produto', foreign_key: 'tipoProdutoid', dependent: :restrict_with_error,
                      inverse_of: :tipo_produto
end
