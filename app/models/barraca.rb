class Barraca < ApplicationRecord
  self.table_name = 'Barraca'
  
  # Associations
  belongs_to :praia, class_name: 'Praia', foreign_key: 'PraiaId'
  belongs_to :status_barraca, class_name: 'StatusBarraca', foreign_key: 'StatusBarracaId'
  belongs_to :tipo_area_cobertura, class_name: 'TipoAreaCobertura', foreign_key: 'TipoAreaCoberturaId'
  
  has_many :contas, class_name: 'Conta', foreign_key: 'barracaid', dependent: :destroy
  has_many :items, class_name: 'Item', foreign_key: 'barracaid', dependent: :destroy
  has_many :operadors, class_name: 'Operador', foreign_key: 'BarracaId', dependent: :destroy
  has_many :usuario_barracas, class_name: 'UsuarioBarraca', foreign_key: 'barracaid', dependent: :destroy
  has_many :usuarios, through: :usuario_barracas
  
  # Validations
  validates :Nome, presence: true, length: { maximum: 255 }
  validates :Numero, presence: true
  validates :Latitude, :Longitude, presence: true, numericality: true
  validates :PercentualComissao, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  
  # Scopes
  scope :by_praia, ->(praia_id) { where(PraiaId: praia_id) }
end
