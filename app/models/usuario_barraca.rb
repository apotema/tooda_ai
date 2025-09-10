# == Schema Information
#
# Table name: UsuarioBarraca
#
#  Id        :integer          not null, primary key
#  barracaid :integer          not null
#  usuarioid :integer          not null
#
# Foreign Keys
#
#  FK_UsuarioBarraca_Barraca  (barracaid => Barraca.Id)
#  FK_UsuarioBarraca_Usuario  (usuarioid => Usuario.Id)
#
class UsuarioBarraca < ApplicationRecord
  self.table_name = 'UsuarioBarraca'

  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'usuarioid', inverse_of: :usuario_barracas
  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'barracaid', inverse_of: :usuario_barracas
end
