class UsuarioBarraca < ApplicationRecord
  self.table_name = 'UsuarioBarraca'

  belongs_to :usuario, class_name: 'Usuario', foreign_key: 'usuarioid'
  belongs_to :barraca, class_name: 'Barraca', foreign_key: 'barracaid'
end
