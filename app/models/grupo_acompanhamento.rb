# == Schema Information
#
# Table name: GrupoAcompanhamento
#
#  Id          :integer          not null, primary key
#  excluido    :boolean
#  itemId      :integer          not null
#  nome        :string(50)       not null
#  obrigatorio :boolean          not null
#  qtdMax      :integer          not null
#  qtdMin      :integer          not null
#
# Foreign Keys
#
#  FK_Item_GrupoAcompanhamento  (itemId => Item.Id)
#
class GrupoAcompanhamento < ApplicationRecord
  self.table_name = 'GrupoAcompanhamento'

  has_many :item_acompanhamentos, class_name: 'ItemAcompanhamento', foreign_key: 'grupoAcompanhamentoId',
                                  dependent: :restrict_with_error, inverse_of: :grupo_acompanhamento
end
