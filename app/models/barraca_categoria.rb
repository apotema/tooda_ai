# == Schema Information
#
# Table name: BarracaCategoria
#
#  Ativa     :boolean          not null
#  BarracaId :integer          not null
#  Excluida  :boolean          not null
#  Id        :integer          not null, primary key
#  Nome      :string(60)       not null
#  Ordem     :integer          not null
#
# Foreign Keys
#
#  FK_BarracaCategoria_Barraca  (BarracaId => Barraca.Id)
#
class BarracaCategoria < ApplicationRecord
  self.table_name = 'BarracaCategoria'

  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'BarracaId', inverse_of: false

  has_many :items, class_name: 'Item', foreign_key: 'BarracaCategoriaId', dependent: :restrict_with_error,
                   inverse_of: :barraca_categoria
end
