require "rails_helper"

RSpec.describe "Validador::Eventos", type: :request do
  let(:validador) { create(:validador) }
  let!(:pendente)  { create(:evento, :pendente, data_evento: 5.days.from_now) }
  let!(:aprovado)  { create(:evento, :aprovado) }
  let!(:rejeitado) { create(:evento, :rejeitado, excluido_em: Time.current) }

  before { sign_in validador, scope: :validador }

  describe "GET /validador/eventos" do
    it "lista pendentes por padrão" do
      get validador_eventos_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(pendente.titulo)
      expect(response.body).not_to include(aprovado.titulo)
    end

    it "filtra por situação" do
      get validador_eventos_path(situacao: "aprovado")
      expect(response.body).to include(aprovado.titulo)
      expect(response.body).not_to include(pendente.titulo)
    end
  end

  describe "POST /validador/eventos/:id/aprovar" do
    it "aprova o evento" do
      post aprovar_validador_evento_path(pendente)
      expect(pendente.reload.situacao).to eq("aprovado")
      expect(PublicarPostagensSociaisJob).to have_been_enqueued.with(pendente.id)
    end
  end

  describe "POST /validador/eventos/:id/reprovar" do
    it "reprova com motivo" do
      post reprovar_validador_evento_path(pendente), params: { motivo_rejeicao: "fora do escopo" }
      pendente.reload
      expect(pendente.situacao).to eq("rejeitado")
      expect(pendente.motivo_rejeicao).to eq("fora do escopo")
    end
  end

  describe "PATCH /validador/eventos/:id" do
    it "atualiza o evento e registra log" do
      patch validador_evento_path(pendente), params: { evento: { titulo: "Novo" } }
      expect(pendente.reload.titulo).to eq("Novo")
      expect(RegistroAcao.where(acao: "editar").count).to eq(1)
    end
  end

  describe "DELETE /validador/eu" do
    it "auto-exclui o validador" do
      delete validador_auto_exclusao_path
      expect(validador.reload.excluido?).to be(true)
      expect(RegistroAcao.where(acao: "auto_excluir").count).to eq(1)
    end
  end
end
