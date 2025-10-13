# == Schema Information
#
# Table name: Praia
#
#  Cidade :string(20)       not null
#  Id     :integer          not null, primary key
#  Nome   :string(70)       not null
#  Uf     :string(3)        not null
#
class Praia < ApplicationRecord
  self.table_name = 'Praia'

  has_many :barracas, class_name: 'Barraca', foreign_key: 'PraiaId', dependent: :restrict_with_error, inverse_of: :praia

  # Ransack configuration
  def self.ransackable_attributes(_auth_object = nil)
    %w[Id Nome Cidade Uf]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[barracas]
  end
end
