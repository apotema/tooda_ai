# == Schema Information
#
# Table name: StatusBarraca
#
#  Id     :integer          not null, primary key
#  Status :string(50)       not null
#
class StatusBarraca < ApplicationRecord
  self.table_name = 'StatusBarraca'

  has_many :barracas, class_name: 'Barraca', foreign_key: 'StatusBarracaId', dependent: :restrict_with_error,
                      inverse_of: :status_barraca
end
