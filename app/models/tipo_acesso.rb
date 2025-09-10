# == Schema Information
#
# Table name: TipoAcesso
#
#  Id   :integer          not null, primary key
#  Tipo :string(20)       not null
#
class TipoAcesso < ApplicationRecord
  self.table_name = 'TipoAcesso'

  has_many :usuarios, class_name: 'Usuario', foreign_key: 'tipoacessoid', dependent: :restrict_with_error,
                      inverse_of: :tipo_acesso
end
