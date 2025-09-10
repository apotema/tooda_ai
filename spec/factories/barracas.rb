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
FactoryBot.define do
  factory :barraca do
    sequence(:Id) { |n| n }
    sequence(:Nome) { |n| "Barraca #{n}" }
    sequence(:Numero, &:to_s)
    Latitude { -23.5 }
    Longitude { -46.6 }
    PercentualComissao { 10.0 }
    PercentualComissaoCartao { 5.0 }
    Ordem { 1 }
    DataInclusao { Time.current }

    # Use foreign key ids instead of associations for complex models
    after(:build) do |barraca|
      barraca.PraiaId ||= create(:praia).Id
      barraca.StatusBarracaId ||= create(:status_barraca).Id
      barraca.TipoAreaCoberturaId ||= create(:tipo_area_cobertura).Id
      barraca.TipoBarracaId ||= create(:tipo_barraca).Id
    end
  end
end
