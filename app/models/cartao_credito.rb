class CartaoCredito < ApplicationRecord
  self.table_name = 'CartaoCredito'

  belongs_to :bandeira, class_name: 'Bandeira', foreign_key: 'BandeiraId', inverse_of: false
  belongs_to :status_cartao, class_name: 'StatusCartao', foreign_key: 'StatusCartaoId', inverse_of: false

  has_many :contas, class_name: 'Conta', foreign_key: 'CartaoCreditoId', dependent: :restrict_with_error,
                    inverse_of: :cartao_credito
end
