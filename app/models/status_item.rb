class StatusItem < ApplicationRecord
  self.table_name = 'StatusItem'
  
  has_many :items, class_name: 'Item', foreign_key: 'statusItemId', dependent: :restrict_with_error
end