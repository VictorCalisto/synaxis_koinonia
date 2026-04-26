class NotificacaoAprovacaoJob < ApplicationJob
  queue_as :mailers

  def perform(evento_id)
    evento = Evento.find(evento_id)
    return if evento.email_submissor.blank?

    ValidacaoMailer.aprovado(evento.id).deliver_now
  end
end
