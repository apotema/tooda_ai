# == Schema Information
#
# Table name: FormaPagamento
#
#  Codigo :string(20)       not null
#  Id     :integer          not null, primary key
#  Tipo   :string(50)       not null
#  ativo  :boolean          not null
#
class FormaPagamento < ApplicationRecord
  self.table_name = 'FormaPagamento'

  has_many :contas, class_name: 'Conta', foreign_key: 'formapagamentoid', dependent: :restrict_with_error,
                    inverse_of: :forma_pagamento
end
