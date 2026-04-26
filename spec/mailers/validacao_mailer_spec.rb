require "rails_helper"

RSpec.describe ValidacaoMailer, type: :mailer do
  let(:evento) { create(:evento, :aprovado, :com_email_submissor) }

  describe "#aprovado" do
    let(:mail) { ValidacaoMailer.aprovado(evento.id) }

    it "enviado para o email do submissor" do
      expect(mail.to).to eq([evento.email_submissor])
    end

    it "mencionado evento aprovado" do
      expect(mail.body.encoded).to include(evento.titulo)
    end
  end

  describe "#reprovado" do
    let(:evento_rejeitado) { create(:evento, :rejeitado, :com_email_submissor, motivo_rejeicao: "Não atende critérios") }
    let(:mail) { ValidacaoMailer.reprovado(evento_rejeitado.id) }

    it "enviado para o email do submissor" do
      expect(mail.to).to eq([evento_rejeitado.email_submissor])
    end

    it "menciona rejeição" do
      # The message says "não foi aprovado para divulgação"
      expect(mail.body.encoded).to match(/aprovado.*divulga/i)
    end

    it "inclui motivo da rejeição" do
      # HTML encoding pode mudar a formatação, então fazemos match flexível
      expect(mail.body.encoded).to match(/atende/i)
    end
  end
end
