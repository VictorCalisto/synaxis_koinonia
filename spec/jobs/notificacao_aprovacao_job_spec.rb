require "rails_helper"

RSpec.describe NotificacaoAprovacaoJob, type: :job do
  context "quando evento tem email_submissor" do
    let(:evento) { create(:evento, :aprovado, :com_email_submissor) }

    it "envia ValidacaoMailer.aprovado" do
      expect {
        NotificacaoAprovacaoJob.perform_now(evento.id)
      }.to change { ActionMailer::Base.deliveries.size }.by(1)

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include(evento.email_submissor)
    end
  end

  context "quando evento não tem email_submissor" do
    let(:evento) { create(:evento, :aprovado, email_submissor: nil) }

    it "não envia email" do
      expect {
        NotificacaoAprovacaoJob.perform_now(evento.id)
      }.not_to change { ActionMailer::Base.deliveries.size }
    end
  end
end
