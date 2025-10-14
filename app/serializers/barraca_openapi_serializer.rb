class BarracaOpenapiSerializer < ActiveModel::Serializer
  include LlmTranslator

  # LLM-friendly attributes (English names, readable values)
  attributes :id, :name, :number, :license, :tax_id, :pix_key,
             :latitude, :longitude, :order, :commission_percentage,
             :card_commission_percentage, :delivery_radius, :delivery_fee,
             :service_fee, :qr_code_url, :qr_code_backup_url, :created_at,
             :status, :beach_id, :type_id, :coverage_type_id

  # Delegate simple attribute mappings to object
  delegate :Id, :Nome, :Numero, :Licenca, :CpfCnpj, :ChavePix,
           :Latitude, :Longitude, :Ordem, :PercentualComissao,
           :PercentualComissaoCartao, :RaioEntrega, :TaxaEntrega,
           :TaxaServico, :UrlQrCode, :UrlQrCodeBackup, :DataInclusao,
           :PraiaId, :StatusBarracaId, :TipoBarracaId, :TipoAreaCoberturaId, to: :object

  # Attribute mappings
  alias id Id
  alias name Nome
  alias number Numero
  alias license Licenca
  alias tax_id CpfCnpj
  alias pix_key ChavePix
  alias latitude Latitude
  alias longitude Longitude
  alias order Ordem
  alias commission_percentage PercentualComissao
  alias card_commission_percentage PercentualComissaoCartao
  alias delivery_radius RaioEntrega
  alias delivery_fee TaxaEntrega
  alias service_fee TaxaServico
  alias qr_code_url UrlQrCode
  alias qr_code_backup_url UrlQrCodeBackup
  alias created_at DataInclusao
  alias beach_id PraiaId
  alias type_id TipoBarracaId
  alias coverage_type_id TipoAreaCoberturaId

  # Translated status using generic translator
  def status
    translation(:barracas, :status).output(object.StatusBarracaId) || 'unknown'
  end
end
