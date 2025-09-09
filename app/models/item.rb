class Item < ApplicationRecord
  self.table_name = 'Item'

  # Associations
  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'barracaid'
  belongs_to :produto, class_name: 'Produto', foreign_key: 'produtoid'
  belongs_to :status_item, class_name: 'StatusItem', foreign_key: 'statusItemId'
  belongs_to :barraca_categoria, class_name: 'BarracaCategoria', foreign_key: 'BarracaCategoriaId', optional: true

  has_many :pedido_items, class_name: 'PedidoItem', foreign_key: 'itemid', dependent: :destroy

  # Validations
  validates :valor, presence: true, numericality: { greater_than: 0 }

  # Scopes
  scope :active, -> { where(Excluido: false) }
  scope :excluded, -> { where(Excluido: true) }
end
