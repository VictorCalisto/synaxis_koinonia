class PublicarPostagensSociaisJob < ApplicationJob
  queue_as :default

  # Fan-out: enfileira uma PublicarNaPlataformaJob por plataforma do enum.
  def perform(evento_id)
    PostagemSocial.plataformas.each_key do |plataforma|
      PublicarNaPlataformaJob.perform_later(evento_id, plataforma)
    end
  end
end
