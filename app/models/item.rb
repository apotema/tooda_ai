# == Schema Information
#
# Table name: Item
#
#  BarracaCategoriaId :integer
#  Excluido           :boolean          not null
#  Id                 :integer          not null, primary key
#  NomeImpressora     :string(100)
#  Ordem              :integer
#  barracaid          :integer          not null
#  produtoid          :integer          not null
#  qtdMax             :integer
#  statusItemId       :integer          not null
#  valor              :decimal(10, 2)   not null
#
# Foreign Keys
#
#  FK_Item_Barraca    (barracaid => Barraca.Id)
#  FK_Item_Categoria  (BarracaCategoriaId => BarracaCategoria.Id)
#  FK_Item_Produto    (produtoid => Produto.Id)
#  FK_Item_Status     (statusItemId => StatusItem.Id)
#
class Item < ApplicationRecord
  self.table_name = 'Item'

  # Associations
  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'barracaid', inverse_of: :items
  belongs_to :produto, class_name: 'Produto', foreign_key: 'produtoid', inverse_of: :items
  belongs_to :status_item, class_name: 'StatusItem', foreign_key: 'statusItemId', inverse_of: :items
  belongs_to :barraca_categoria, class_name: 'BarracaCategoria', foreign_key: 'BarracaCategoriaId', optional: true,
                                 inverse_of: :items

  has_many :pedido_items, class_name: 'PedidoItem', foreign_key: 'itemid', dependent: :destroy, inverse_of: :item

  # Validations
  validates :valor, presence: true, numericality: { greater_than: 0 }

  # Scopes
  scope :active, -> { where(Excluido: false) }
  scope :excluded, -> { where(Excluido: true) }
end
