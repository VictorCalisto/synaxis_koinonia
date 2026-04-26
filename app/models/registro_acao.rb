class RegistroAcao < ApplicationRecord
  include RemovivelSuavemente

  self.table_name = "registros_acao"

  belongs_to :evento, optional: true

  validates :tipo_ator, :acao, presence: true

  TIPOS_ATOR = %w[Validador Admin Submissor Sistema].freeze
  ACOES = %w[
    aprovar reprovar editar
    submissor_criar submissor_editar submissor_excluir
    convidar_validador remover_validador
    auto_excluir publicacao_falhou
  ].freeze

  validates :tipo_ator, inclusion: { in: TIPOS_ATOR }
  validates :acao,      inclusion: { in: ACOES }

  def self.registrar!(acao:, evento: nil, ator: nil, ator_email: nil, detalhes: {})
    tipo_ator =
      if ator
        ator.class.name
      elsif acao.to_s.start_with?("submissor_")
        "Submissor"
      elsif ator_email.present?
        "Submissor"
      else
        "Sistema"
      end

    create!(
      tipo_ator: tipo_ator,
      ator_id: ator&.id,
      ator_email: ator_email || ator.try(:email),
      evento: evento,
      acao: acao,
      detalhes: detalhes
    )
  end
end
