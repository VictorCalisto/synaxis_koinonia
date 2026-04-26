require "rails_helper"

RSpec.describe "Aceitação de convite de validador", type: :request do
  let(:admin) { create(:admin) }
  let(:convite) { ConviteValidador.create!(email: "novo@x.com", admin: admin) }

  describe "GET /validador/aceitar-convite/:token" do
    it "200 quando válido" do
      get aceitar_convite_path(convite.token)
      expect(response).to have_http_status(:ok)
    end

    it "410 quando expirado" do
      convite.update!(expira_em: 1.day.ago)
      get aceitar_convite_path(convite.token)
      expect(response).to have_http_status(:gone)
    end

    it "404 quando token inexistente" do
      get aceitar_convite_path("nope")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /validador/aceitar-convite/:token" do
    it "cria validador quando senhas conferem" do
      expect {
        patch confirmar_convite_path(convite.token), params: {
          convite: { senha: "senha12345", senha_confirmacao: "senha12345" }
        }
      }.to change(Validador, :count).by(1)
      expect(response).to redirect_to(new_validador_session_path)
    end

    it "rejeita quando senhas diferem" do
      patch confirmar_convite_path(convite.token), params: {
        convite: { senha: "a", senha_confirmacao: "b" }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
