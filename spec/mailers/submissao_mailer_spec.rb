require "rails_helper"

RSpec.describe SubmissaoMailer, type: :mailer do
  let(:evento) { create(:evento, :pendente, :com_email_submissor, :com_token_edicao) }

  describe "#link_magico" do
    let(:mail) { SubmissaoMailer.link_magico(evento.id) }

    it "enviado para o email do submissor" do
      expect(mail.to).to eq([evento.email_submissor])
    end

    it "inclui a URL de edição" do
      expect(mail.body.encoded).to include(evento.token_edicao)
    end

    it "menciona que o link expira" do
      expect(mail.body.encoded).to match(/expira/i)
    end
  end
end
