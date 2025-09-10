# == Schema Information
#
# Table name: StatusItem
#
#  Id     :integer          not null, primary key
#  Status :string(50)       not null
#
class StatusItem < ApplicationRecord
  self.table_name = 'StatusItem'

  has_many :items, class_name: 'Item', foreign_key: 'statusItemId', dependent: :restrict_with_error,
                   inverse_of: :status_item
end
