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
FactoryBot.define do
  factory :produto do
    sequence(:Id) { |n| n }
    sequence(:nome) { |n| "Produto #{n}" }
    ativo { true }
    Ordem { 1 }
    Excluido { false }

    after(:build) do |produto|
      produto.tipoProdutoid ||= create(:tipo_produto).Id
    end
  end
end
