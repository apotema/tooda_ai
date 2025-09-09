class CartaoCredito < ApplicationRecord
  self.table_name = 'CartaoCredito'

  belongs_to :bandeira, class_name: 'Bandeira', foreign_key: 'BandeiraId'
  belongs_to :status_cartao, class_name: 'StatusCartao', foreign_key: 'StatusCartaoId'

  has_many :contas, class_name: 'Conta', foreign_key: 'CartaoCreditoId', dependent: :restrict_with_error
end
