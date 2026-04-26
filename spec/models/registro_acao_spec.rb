require "rails_helper"

RSpec.describe RegistroAcao, type: :model do
  describe ".registrar!" do
    it "registra ação de validador" do
      validador = create(:validador)
      evento = create(:evento, :pendente)
      log = described_class.registrar!(acao: "aprovar", evento: evento, ator: validador)
      expect(log.tipo_ator).to eq("Validador")
      expect(log.ator_id).to eq(validador.id)
      expect(log.ator_email).to eq(validador.email)
    end

    it "registra ação de submissor sem ator_id" do
      evento = create(:evento, :pendente)
      log = described_class.registrar!(
        acao: "submissor_criar",
        evento: evento,
        ator_email: "anon@test.local"
      )
      expect(log.tipo_ator).to eq("Submissor")
      expect(log.ator_id).to be_nil
      expect(log.ator_email).to eq("anon@test.local")
    end
  end

  describe "validações de inclusão" do
    it "rejeita tipo_ator fora da lista" do
      log = described_class.new(tipo_ator: "Fantasma", acao: "aprovar")
      expect(log).not_to be_valid
    end

    it "rejeita acao fora da lista" do
      log = described_class.new(tipo_ator: "Admin", acao: "explodir")
      expect(log).not_to be_valid
    end
  end
end
