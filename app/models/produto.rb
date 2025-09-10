# == Schema Information
#
# Table name: Produto
#
#  BarracaId     :integer
#  Excluido      :boolean          not null
#  Id            :integer          not null, primary key
#  Ordem         :integer          not null
#  QtdItens      :integer          default(1), not null
#  ativo         :boolean          not null
#  cest          :string(20)
#  cfop          :string(20)
#  cofins        :string(20)
#  csosn         :string(20)
#  detalhe       :string(300)
#  icms          :string(20)
#  ipi           :string(20)
#  ncm           :string(20)
#  nome          :string(50)       not null
#  origemIcms    :string(20)
#  pis           :string(20)
#  tipoProdutoid :integer          not null
#
# Foreign Keys
#
#  FK_Item_TipoProduto  (tipoProdutoid => TipoProduto.Id)
#
class Produto < ApplicationRecord
  self.table_name = 'Produto'

  # Associations
  belongs_to :tipo_produto, class_name: 'TipoProduto', foreign_key: 'tipoProdutoid', inverse_of: :produtos
  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'BarracaId', optional: true, inverse_of: false

  has_many :items, class_name: 'Item', foreign_key: 'produtoid', dependent: :destroy, inverse_of: :produto

  # Validations
  validates :nome, presence: true, length: { maximum: 255 }

  # Scopes
  scope :active, -> { where(ativo: true, Excluido: false) }
  scope :inactive, -> { where(ativo: false) }
  scope :excluded, -> { where(Excluido: true) }
end
