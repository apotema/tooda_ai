# == Schema Information
#
# Table name: CartaoCredito
#
#  BandeiraId     :integer          not null
#  DataCriacao    :datetime         not null
#  DataValidade   :datetime         not null
#  Id             :bigint           not null, primary key
#  Nome           :string(150)      not null
#  Numero         :string(30)       not null
#  Principal      :boolean          not null
#  StatusCartaoId :integer          not null
#
# Foreign Keys
#
#  FK_Cartao_Bandeira  (BandeiraId => Bandeira.Id)
#  FK_Cartao_Status    (StatusCartaoId => StatusCartao.Id)
#
class CartaoCredito < ApplicationRecord
  self.table_name = 'CartaoCredito'

  belongs_to :bandeira, class_name: 'Bandeira', foreign_key: 'BandeiraId', inverse_of: false
  belongs_to :status_cartao, class_name: 'StatusCartao', foreign_key: 'StatusCartaoId', inverse_of: false

  has_many :contas, class_name: 'Conta', foreign_key: 'CartaoCreditoId', dependent: :restrict_with_error,
                    inverse_of: :cartao_credito
end
