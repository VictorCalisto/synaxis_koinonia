require "rails_helper"

RSpec.describe Evento, type: :model do
  describe "validações" do
    it { is_expected.to validate_presence_of(:titulo) }
    it { is_expected.to validate_presence_of(:organizacao) }
    it { is_expected.to validate_presence_of(:local) }
    it { is_expected.to validate_presence_of(:cidade) }
    it { is_expected.to validate_presence_of(:descricao) }
    it { is_expected.to validate_presence_of(:perfil_divulgacao) }
    it { is_expected.to validate_presence_of(:contato_publico) }
    it { is_expected.to validate_presence_of(:caminho_banner) }
    it { is_expected.to validate_presence_of(:data_evento) }
  end

  describe "enum situacao" do
    it { is_expected.to define_enum_for(:situacao).with_values(pendente: 0, aprovado: 1, rejeitado: 2) }
    it "padrão é pendente" do
      expect(described_class.new.situacao).to eq("pendente")
    end
  end

  describe "scopes" do
    let!(:futuro)       { create(:evento, :aprovado, data_evento: 3.days.from_now) }
    let!(:passado)      { create(:evento, :aprovado, data_evento: 3.days.ago) }
    let!(:outra_cidade) { create(:evento, :aprovado, cidade: "Rio", data_evento: 2.days.from_now) }

    it "futuros retorna apenas eventos no futuro" do
      expect(described_class.futuros).to include(futuro, outra_cidade)
      expect(described_class.futuros).not_to include(passado)
    end

    it "por_cidade filtra case-insensitive" do
      expect(described_class.por_cidade("são paulo")).to include(futuro)
      expect(described_class.por_cidade("são paulo")).not_to include(outra_cidade)
    end

    it "aprovados retorna apenas aprovados" do
      pendente = create(:evento, :pendente)
      expect(described_class.aprovado).to include(futuro, outra_cidade, passado)
      expect(described_class.aprovado).not_to include(pendente)
    end
  end

  describe "token de edição" do
    let(:evento) { create(:evento, :pendente) }

    it "gerar_token_edicao! define token e expiração" do
      evento.gerar_token_edicao!
      expect(evento.token_edicao).to be_present
      expect(evento.token_expira_em).to be_within(5.seconds).of(24.hours.from_now)
    end

    it "token_valido? é falso após expirar" do
      evento.gerar_token_edicao!
      evento.update!(token_expira_em: 1.minute.ago)
      expect(evento.token_valido?).to be(false)
    end

    it "token_valido? é falso se não for mais pendente" do
      evento.gerar_token_edicao!
      evento.update!(situacao: :aprovado, aprovado_em: Time.current)
      expect(evento.token_valido?).to be(false)
    end

    it "limpar_token_edicao! remove ambos" do
      evento.gerar_token_edicao!
      evento.limpar_token_edicao!
      expect(evento.token_edicao).to be_nil
      expect(evento.token_expira_em).to be_nil
    end
  end

  describe "soft delete" do
    it "excluir_suavemente! define excluido_em e remove do default scope" do
      evento = create(:evento, :pendente)
      evento.excluir_suavemente!
      expect(evento.reload.excluido_em).to be_present
      expect(described_class.where(id: evento.id)).to be_empty
      expect(described_class.com_excluidos.where(id: evento.id)).to include(evento)
    end
  end
end
