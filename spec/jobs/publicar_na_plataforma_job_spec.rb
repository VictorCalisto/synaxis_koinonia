require "rails_helper"

RSpec.describe PublicarNaPlataformaJob, type: :job do
  let(:evento) { create(:evento, :pendente) }

  it "publica na plataforma e cria PostagemSocial" do
    adapter_mock = instance_double("Adapter", publicar: { id_externo: "123", url_externa: "https://example.com/post" })
    allow(PublicadorSocial).to receive(:adapter_para).and_return(adapter_mock)

    expect {
      PublicarNaPlataformaJob.perform_now(evento.id, "instagram")
    }.to change(PostagemSocial, :count).by(1)

    postagem = PostagemSocial.last
    expect(postagem.evento_id).to eq(evento.id)
    expect(postagem.plataforma).to eq("instagram")
    expect(postagem.id_externo).to eq("123")
  end

  context "quando todas as plataformas estão publicadas" do
    it "enfileira NotificacaoAprovacaoJob" do
      adapter_mock = instance_double("Adapter", publicar: { id_externo: "123", url_externa: "https://example.com/post" })
      allow(PublicadorSocial).to receive(:adapter_para).and_return(adapter_mock)

      create(:postagem_social, evento: evento, plataforma: "facebook")
      create(:postagem_social, evento: evento, plataforma: "twitter")

      expect {
        PublicarNaPlataformaJob.perform_now(evento.id, "instagram")
      }.to change(enqueued_jobs, :size).by(1)

      expect(enqueued_jobs.last[:job]).to eq(NotificacaoAprovacaoJob)
    end
  end

  context "quando a publicação falha" do
    it "registra RegistroAcao com falha" do
      adapter_mock = instance_double("Adapter")
      allow(adapter_mock).to receive(:publicar).and_raise(PublicadorSocial::Erro, "API Error")
      allow(PublicadorSocial).to receive(:adapter_para).and_return(adapter_mock)

      begin
        PublicarNaPlataformaJob.perform_now(evento.id, "instagram")
      rescue PublicadorSocial::Erro
        # Expected
      end

      expect(RegistroAcao.last.acao).to eq("publicacao_falhou")
    end
  end
end
