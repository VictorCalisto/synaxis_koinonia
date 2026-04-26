class AprovarEvento
  def self.call(evento:, validador:)
    new(evento: evento, validador: validador).call
  end

  def initialize(evento:, validador:)
    @evento = evento
    @validador = validador
  end

  def call
    return Resultado.erro("Evento já rejeitado") if @evento.rejeitado?

    Evento.transaction do
      @evento.update!(
        situacao: :aprovado,
        aprovado_em: Time.current,
        token_edicao: nil,
        token_expira_em: nil
      )
      RegistroAcao.registrar!(acao: "aprovar", evento: @evento, ator: @validador)
    end

    PublicarPostagensSociaisJob.perform_later(@evento.id)
    Resultado.ok(@evento)
  end
end
