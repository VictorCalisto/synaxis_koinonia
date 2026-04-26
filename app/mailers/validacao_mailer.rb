class ValidacaoMailer < ApplicationMailer
  def aprovado(evento_id)
    @evento = Evento.find(evento_id)
    return if @evento.email_submissor.blank?

    @postagens = PostagemSocial.where(evento_id: @evento.id)
    mail(to: @evento.email_submissor, subject: "Seu evento foi aprovado e publicado")
  end

  def reprovado(evento_id)
    @evento = Evento.com_excluidos.find(evento_id)
    return if @evento.email_submissor.blank? || @evento.motivo_rejeicao.blank?

    mail(to: @evento.email_submissor, subject: "Sobre o evento que você enviou")
  end
end
