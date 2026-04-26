class ConviteValidadorMailer < ApplicationMailer
  def convite(convite_id)
    @convite = ConviteValidador.find(convite_id)
    @url = aceitar_convite_url(@convite.token)
    mail(to: @convite.email, subject: "Convite para ser validador no Synaxis Koinonia")
  end
end
