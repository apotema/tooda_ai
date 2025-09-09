class UsuarioBarraca < ApplicationRecord
  self.table_name = 'UsuarioBarraca'

  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'usuarioid', inverse_of: :usuario_barracas
  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'barracaid', inverse_of: :usuario_barracas
end
