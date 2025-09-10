# == Schema Information
#
# Table name: Barraca
#
#  ChavePix                 :string(100)
#  CpfCnpj                  :string(15)
#  DataInclusao             :datetime         not null
#  Id                       :integer          not null, primary key
#  Latitude                 :string(50)
#  Licenca                  :string(50)
#  Longitude                :string(50)
#  Nome                     :string(70)       not null
#  Numero                   :string(50)
#  Ordem                    :integer          not null
#  PercentualComissao       :decimal(5, 2)
#  PercentualComissaoCartao :decimal(5, 2)    not null
#  PraiaId                  :integer
#  RaioEntrega              :integer
#  StatusBarracaId          :integer          not null
#  TaxaEntrega              :decimal(18, 2)
#  TaxaServico              :decimal(18, 2)
#  TipoAreaCoberturaId      :integer          not null
#  TipoBarracaId            :integer          not null
#  UrlQrCode                :string(100)
#  UrlQrCodeBackup          :varchar(100)
#
# Foreign Keys
#
#  FK_Barraca_Praia              (PraiaId => Praia.Id)
#  FK_Barraca_Status             (StatusBarracaId => StatusBarraca.Id)
#  FK_Barraca_TipoAreaCobertura  (TipoAreaCoberturaId => TipoAreaCobertura.Id)
#
class Barraca < ApplicationRecord
  self.table_name = 'Barraca'

  # Associations
  belongs_to :praia, class_name: 'Praia', foreign_key: 'PraiaId', inverse_of: false
  belongs_to :status_barraca, class_name: 'StatusBarraca', foreign_key: 'StatusBarracaId', inverse_of: false
  belongs_to :tipo_area_cobertura, class_name: 'TipoAreaCobertura', foreign_key: 'TipoAreaCoberturaId',
                                   inverse_of: false

  has_many :contas, class_name: 'Conta', foreign_key: 'barracaid', dependent: :destroy, inverse_of: :barraca
  has_many :items, class_name: 'Item', foreign_key: 'barracaid', dependent: :destroy, inverse_of: :barraca
  has_many :operadors, class_name: 'Operador', foreign_key: 'BarracaId', dependent: :destroy, inverse_of: false
  has_many :usuario_barracas, class_name: 'UsuarioBarraca', foreign_key: 'barracaid', dependent: :destroy,
                              inverse_of: :barraca
  has_many :usuarios, through: :usuario_barracas

  # Validations
  validates :Nome, presence: true, length: { maximum: 255 }
  validates :Numero, presence: true
  validates :Latitude, :Longitude, presence: true, numericality: true
  validates :PercentualComissao, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  # Scopes
  scope :by_praia, ->(praia_id) { where(PraiaId: praia_id) }
end
