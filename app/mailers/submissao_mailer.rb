class SubmissaoMailer < ApplicationMailer
  def link_magico(evento_id)
    @evento = Evento.find(evento_id)
    @url_edicao = edicao_token_url(@evento.token_edicao)
    @expira_em  = @evento.token_expira_em

    mail(
      to: @evento.email_submissor,
      subject: "Seu evento foi recebido — link de edição"
    )
  end
end
