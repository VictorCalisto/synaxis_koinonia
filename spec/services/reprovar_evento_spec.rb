require "rails_helper"

RSpec.describe ReprovarEvento do
  let(:validador) { create(:validador) }

  context "com email_submissor e motivo" do
    let(:evento) { create(:evento, :pendente, :com_email_submissor) }

    it "reprova, soft-deleta, limpa token e envia email" do
      resultado = described_class.call(evento: evento, validador: validador, motivo: "Fora do escopo")
      expect(resultado).to be_sucesso

      evento.reload
      expect(evento.situacao).to eq("rejeitado")
      expect(evento.excluido?).to be(true)
      expect(evento.token_edicao).to be_nil
      expect(evento.motivo_rejeicao).to eq("Fora do escopo")

      expect(enqueued_jobs.any? { |j| j[:args].first == "ValidacaoMailer" && j[:args].second == "reprovado" }).to be(true)
    end

    it "registra RegistroAcao de reprovar com motivo" do
      described_class.call(evento: evento, validador: validador, motivo: "x")
      log = RegistroAcao.last
      expect(log.acao).to eq("reprovar")
      expect(log.detalhes["motivo"]).to eq("x")
    end
  end

  context "sem email_submissor" do
    let(:evento) { create(:evento, :pendente) }

    it "reprova mas NÃO envia email" do
      expect {
        described_class.call(evento: evento, validador: validador, motivo: "qualquer")
      }.not_to have_enqueued_mail(ValidacaoMailer, :reprovado)
    end
  end

  context "sem motivo" do
    let(:evento) { create(:evento, :pendente, :com_email_submissor) }

    it "reprova mas NÃO envia email quando motivo vazio" do
      expect {
        described_class.call(evento: evento, validador: validador, motivo: "")
      }.not_to have_enqueued_mail(ValidacaoMailer, :reprovado)
    end
  end
end
