class PublicarNaPlataformaJob < ApplicationJob
  queue_as :default
  retry_on PublicadorSocial::Erro, wait: :polynomially_longer, attempts: 5

  def perform(evento_id, plataforma)
    evento = Evento.find(evento_id)
    adapter = PublicadorSocial.adapter_para(plataforma.to_sym)
    retorno = adapter.publicar(evento)

    PostagemSocial.create!(
      evento: evento,
      plataforma: plataforma,
      id_externo: retorno.fetch(:id_externo),
      url_externa: retorno[:url_externa],
      publicado_em: Time.current
    )

    if PostagemSocial.where(evento_id: evento.id).count == PostagemSocial.plataformas.size
      NotificacaoAprovacaoJob.perform_later(evento.id)
    end
  rescue PublicadorSocial::Erro => e
    RegistroAcao.registrar!(
      acao: "publicacao_falhou",
      evento: evento,
      detalhes: { plataforma: plataforma, mensagem: e.message }
    )
    raise
  end
end
