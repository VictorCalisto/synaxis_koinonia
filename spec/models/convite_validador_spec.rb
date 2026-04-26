require "rails_helper"

RSpec.describe ConviteValidador, type: :model do
  describe "callbacks" do
    it "gera token e define expira_em na criação" do
      convite = create(:convite_validador)
      expect(convite.token.length).to be >= 40
      expect(convite.expira_em).to be > 6.days.from_now
    end
  end

  describe "#valido_para_aceitacao?" do
    let(:convite) { create(:convite_validador) }

    it "é verdadeiro quando pendente e não expirado" do
      expect(convite.valido_para_aceitacao?).to be(true)
    end

    it "é falso quando já aceito" do
      convite.update!(aceito_em: Time.current)
      expect(convite.valido_para_aceitacao?).to be(false)
    end

    it "é falso quando expirado" do
      convite.update!(expira_em: 1.day.ago)
      expect(convite.valido_para_aceitacao?).to be(false)
    end
  end

  describe "#aceitar!" do
    it "cria um Validador e marca aceito_em" do
      convite = create(:convite_validador, email: "novo@test.local")
      validador = convite.aceitar!(senha: "senha12345")
      expect(validador).to be_persisted
      expect(validador.email).to eq("novo@test.local")
      expect(convite.reload.aceito_em).to be_present
    end

    it "falha se inválido" do
      convite = create(:convite_validador)
      convite.update!(aceito_em: Time.current)
      expect { convite.aceitar!(senha: "x") }.to raise_error(ArgumentError)
    end
  end
end
