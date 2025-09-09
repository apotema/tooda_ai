FactoryBot.define do
  factory :barraca do
    sequence(:Id) { |n| n }
    sequence(:Nome) { |n| "Barraca #{n}" }
    sequence(:Numero) { |n| n.to_s }
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