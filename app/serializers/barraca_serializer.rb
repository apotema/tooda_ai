class BarracaSerializer < ActiveModel::Serializer
  attributes :Id, :Nome, :Numero, :Licenca, :CpfCnpj, :ChavePix,
             :Latitude, :Longitude, :Ordem, :PercentualComissao,
             :PercentualComissaoCartao, :RaioEntrega, :TaxaEntrega,
             :TaxaServico, :UrlQrCode, :UrlQrCodeBackup, :DataInclusao

  belongs_to :praia
  belongs_to :status_barraca
  belongs_to :tipo_area_cobertura
  belongs_to :tipo_barraca

  # Include related IDs as attributes for convenience
  attribute :PraiaId
  attribute :StatusBarracaId
  attribute :TipoAreaCoberturaId
  attribute :TipoBarracaId
end
