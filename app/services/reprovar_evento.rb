class ReprovarEvento
  def self.call(evento:, validador:, motivo: nil)
    new(evento: evento, validador: validador, motivo: motivo).call
  end

  def initialize(evento:, validador:, motivo: nil)
    @evento = evento
    @validador = validador
    @motivo = motivo.to_s.strip
  end

  def call
    Evento.transaction do
      @evento.update!(
        situacao: :rejeitado,
        rejeitado_em: Time.current,
        motivo_rejeicao: @motivo.presence,
        token_edicao: nil,
        token_expira_em: nil,
        excluido_em: Time.current
      )
      RegistroAcao.registrar!(
        acao: "reprovar",
        evento: @evento,
        ator: @validador,
        detalhes: { motivo: @motivo }
      )
    end

    if enviar_email?
      ValidacaoMailer.reprovado(@evento.id).deliver_later
    end

    Resultado.ok(@evento)
  end

  private

  def enviar_email?
    @evento.rejeitado? && @motivo.present? && @evento.email_submissor.present?
  end
end
