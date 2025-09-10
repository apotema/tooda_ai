# == Schema Information
#
# Table name: Pedido
#
#  Id             :bigint           not null, primary key
#  TaxaEntrega    :decimal(18, 2)
#  contaid        :bigint           not null
#  data           :datetime         not null
#  impresso       :boolean          not null
#  observacao     :string(200)
#  operadorId     :integer
#  statuspedidoid :integer          not null
#  tipoEntregaId  :integer
#  valorDesconto  :decimal(18, 2)
#
# Foreign Keys
#
#  FK_Pedido_Conta        (contaid => Conta.Id)
#  FK_Pedido_Operador     (operadorId => Operador.Id)
#  FK_Pedido_Status       (statuspedidoid => StatusPedido.Id)
#  FK_Pedido_TipoEntrega  (tipoEntregaId => TipoEntrega.Id)
#
FactoryBot.define do
  factory :pedido do
    sequence(:Id) { |n| n }
    data { Time.current }
    impresso { false }

    after(:build) do |pedido|
      pedido.contaid ||= create(:conta).Id
      pedido.statuspedidoid ||= create(:status_pedido).Id
      pedido.tipoEntregaId ||= create(:tipo_entrega).Id
    end

    trait :completed do
      after(:build) do |pedido|
        pedido.statuspedidoid = create(:status_pedido, :completed).Id
      end
    end
  end
end
