# == Schema Information
#
# Table name: TipoBarraca
#
#  Id   :integer          not null, primary key
#  Tipo :string(20)       not null
#
class TipoBarraca < ApplicationRecord
  self.table_name = 'TipoBarraca'

  has_many :barracas, class_name: 'Barraca', foreign_key: 'TipoBarracaId', dependent: :restrict_with_error,
                      inverse_of: false
end
