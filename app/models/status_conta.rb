class StatusConta < ApplicationRecord
  self.table_name = 'StatusConta'

  has_many :contas, class_name: 'Conta', foreign_key: 'statuscontaid', dependent: :restrict_with_error
end
