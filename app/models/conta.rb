class Conta < ApplicationRecord
  self.table_name = 'Conta'
  
  # Associations
  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'barracaid'
  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'usuarioid'
  belongs_to :status_conta, class_name: 'StatusConta', foreign_key: 'statuscontaid'
  belongs_to :forma_pagamento, class_name: 'FormaPagamento', foreign_key: 'formapagamentoid'
  belongs_to :operador, class_name: 'Operador', foreign_key: 'operadorId', optional: true
  belongs_to :cartao_credito, class_name: 'CartaoCredito', foreign_key: 'CartaoCreditoId', optional: true
  
  has_many :pedidos, class_name: 'Pedido', foreign_key: 'contaid', dependent: :destroy
  
  # Validations
  validates :numero, presence: true
  validates :data, presence: true
  validates :identificadorConta, presence: true, uniqueness: true
end