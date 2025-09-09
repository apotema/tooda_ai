class Usuario < ApplicationRecord
  self.table_name = 'Usuario'

  # Associations
  belongs_to :status_usuario, class_name: 'StatusUsuario', foreign_key: 'StatusUsuarioId'
  belongs_to :tipo_acesso, class_name: 'TipoAcesso', foreign_key: 'tipoacessoid'
  belongs_to :tipo_usuario, class_name: 'TipoUsuario', foreign_key: 'tipousuarioid'

  has_many :contas, class_name: 'Conta', foreign_key: 'usuarioid', dependent: :destroy
  has_many :usuario_barracas, class_name: 'UsuarioBarraca', foreign_key: 'usuarioid', dependent: :destroy
  has_many :barracas, through: :usuario_barracas

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nome, presence: true, length: { maximum: 255 }
  validates :cpf, presence: true, uniqueness: true
end
