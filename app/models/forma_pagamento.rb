class FormaPagamento < ApplicationRecord
  self.table_name = 'FormaPagamento'

  has_many :contas, class_name: 'Conta', foreign_key: 'formapagamentoid', dependent: :restrict_with_error
end
