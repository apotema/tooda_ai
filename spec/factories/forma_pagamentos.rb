# == Schema Information
#
# Table name: FormaPagamento
#
#  Codigo :string(20)       not null
#  Id     :integer          not null, primary key
#  Tipo   :string(50)       not null
#  ativo  :boolean          not null
#
FactoryBot.define do
  factory :forma_pagamento do
    sequence(:Id) { |n| n }
    Tipo { 'Dinheiro' }
    ativo { true }
    Codigo { 'DIN' }
  end
end
