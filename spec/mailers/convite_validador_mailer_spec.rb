require "rails_helper"

RSpec.describe ConviteValidadorMailer, type: :mailer do
  let(:admin) { create(:admin) }
  let(:convite) { create(:convite_validador, admin: admin) }

  describe "#convite" do
    let(:mail) { ConviteValidadorMailer.convite(convite.id) }

    it "enviado para o email do convite" do
      expect(mail.to).to eq([convite.email])
    end

    it "inclui link com o token" do
      expect(mail.body.encoded).to match(/validador\/aceitar-convite/i)
    end

    it "menciona que o convite expira" do
      expect(mail.body.encoded).to match(/expira/i)
    end
  end
end
