class Produto < ApplicationRecord
  self.table_name = 'Produto'
  
  # Associations
  belongs_to :tipo_produto, class_name: 'TipoProduto', foreign_key: 'tipoProdutoid'
  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'BarracaId', optional: true
  
  has_many :items, class_name: 'Item', foreign_key: 'produtoid', dependent: :destroy
  
  # Validations
  validates :nome, presence: true, length: { maximum: 255 }
  validates :tipo_produto, presence: true
  
  # Scopes
  scope :active, -> { where(ativo: true, Excluido: false) }
  scope :inactive, -> { where(ativo: false) }
  scope :excluded, -> { where(Excluido: true) }
end