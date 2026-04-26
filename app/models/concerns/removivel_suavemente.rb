module RemovivelSuavemente
  extend ActiveSupport::Concern

  included do
    default_scope { where(excluido_em: nil) }
    scope :excluidos, -> { unscope(where: :excluido_em).where.not(excluido_em: nil) }
    scope :com_excluidos, -> { unscope(where: :excluido_em) }
  end

  def excluir_suavemente!(agora: Time.current)
    update!(excluido_em: agora)
  end

  def excluido?
    excluido_em.present?
  end

  def restaurar!
    update!(excluido_em: nil)
  end
end
