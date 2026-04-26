class ConviteValidador < ApplicationRecord
  include RemovivelSuavemente

  self.table_name = "convites_validadores"

  DURACAO = 7.days

  belongs_to :admin

  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :expira_em, presence: true

  before_validation :gerar_token, on: :create
  before_validation :definir_expiracao, on: :create

  scope :pendentes, -> { where(aceito_em: nil).where("expira_em > ?", Time.current) }

  def aceito?
    aceito_em.present?
  end

  def expirado?
    expira_em < Time.current
  end

  def valido_para_aceitacao?
    !aceito? && !expirado? && !excluido?
  end

  def aceitar!(senha:)
    raise ArgumentError, "convite inválido" unless valido_para_aceitacao?

    validador = nil
    transaction do
      validador = Validador.create!(email: email, password: senha, password_confirmation: senha)
      update!(aceito_em: Time.current)
    end
    validador
  end

  private

  def gerar_token
    self.token ||= SecureRandom.urlsafe_base64(48)
  end

  def definir_expiracao
    self.expira_em ||= DURACAO.from_now
  end
end
