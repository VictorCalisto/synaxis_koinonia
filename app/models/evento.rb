class Evento < ApplicationRecord
  include RemovivelSuavemente

  self.table_name = "eventos"

  DURACAO_TOKEN_EDICAO = 24.hours

  enum :situacao, { pendente: 0, aprovado: 1, rejeitado: 2 }, default: :pendente

  has_many :postagens_sociais, foreign_key: :evento_id, dependent: :destroy
  has_many :registros_acao,    foreign_key: :evento_id, dependent: :nullify

  validates :titulo, :organizacao, :local, :cidade, :descricao,
            :perfil_divulgacao, :contato_publico, :valor, :caminho_banner,
            presence: true
  validates :data_evento, presence: true
  validates :token_edicao, uniqueness: true, allow_nil: true

  scope :aprovados,  -> { where(situacao: :aprovado) }
  scope :futuros,    -> { where("data_evento >= ?", Time.current) }
  scope :por_cidade, ->(cidade) { where("LOWER(cidade) = ?", cidade.to_s.downcase) if cidade.present? }
  scope :ordenados_fila, -> { order(data_evento: :asc, created_at: :asc) }
  scope :proximos_dias, ->(dias) { where(data_evento: Time.current..dias.to_i.days.from_now) }

  def gerar_token_edicao!
    update!(
      token_edicao: SecureRandom.urlsafe_base64(48),
      token_expira_em: DURACAO_TOKEN_EDICAO.from_now
    )
  end

  def limpar_token_edicao!
    update!(token_edicao: nil, token_expira_em: nil)
  end

  def token_valido?
    token_edicao.present? &&
      token_expira_em.present? &&
      token_expira_em > Time.current &&
      pendente?
  end

  def url_publica_banner(host: ENV["APP_HOST"])
    return if caminho_banner.blank?

    File.join(host.to_s, caminho_banner)
  end
end
