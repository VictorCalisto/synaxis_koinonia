require "rails_helper"

RSpec.describe "Edição por token", type: :request do
  let(:evento) do
    evento = create(:evento, :pendente, :com_email_submissor)
    evento.gerar_token_edicao!
    evento
  end

  describe "GET /eventos/editar/:token" do
    it "retorna 200 com o formulário quando o token é válido" do
      get edicao_token_path(evento.token_edicao)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Editar evento")
    end

    it "retorna 404 quando o token não existe" do
      get edicao_token_path("nao-existe")
      expect(response).to have_http_status(:not_found)
    end

    it "retorna 410 quando o token está expirado" do
      evento.update!(token_expira_em: 1.minute.ago)
      get edicao_token_path(evento.token_edicao)
      expect(response).to have_http_status(:gone)
    end

    it "retorna 410 quando o evento não está mais pendente" do
      evento.update!(situacao: :aprovado, aprovado_em: Time.current)
      get edicao_token_path(evento.token_edicao)
      expect(response).to have_http_status(:gone)
    end
  end

  describe "PATCH /eventos/editar/:token" do
    it "atualiza o evento e registra log" do
      expect {
        patch edicao_token_path(evento.token_edicao),
              params: { evento: { titulo: "Novo título" } }
      }.to change(RegistroAcao, :count).by(1)

      expect(evento.reload.titulo).to eq("Novo título")
      expect(response).to redirect_to(edicao_token_path(evento.token_edicao))
    end
  end

  describe "DELETE /eventos/editar/:token" do
    it "soft-deleta o evento e limpa o token" do
      delete edicao_token_path(evento.token_edicao)
      evento.reload
      expect(evento.excluido?).to be(true)
      expect(evento.token_edicao).to be_nil
      expect(response).to redirect_to(nova_submissao_path)
    end
  end
end
