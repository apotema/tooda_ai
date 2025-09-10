# == Schema Information
#
# Table name: StatusConta
#
#  Id     :integer          not null, primary key
#  Status :string(50)       not null
#
class StatusConta < ApplicationRecord
  self.table_name = 'StatusConta'

  has_many :contas, class_name: 'Conta', foreign_key: 'statuscontaid', dependent: :restrict_with_error,
                    inverse_of: :status_conta
end
