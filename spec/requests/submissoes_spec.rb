require "rails_helper"

RSpec.describe "Submissões", type: :request do
  describe "GET /enviar" do
    it "retorna 200 com o formulário" do
      get nova_submissao_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Divulgue seu evento")
    end
  end

  describe "POST /enviar" do
    let(:banner) { banner_upload(size: 400) }
    let(:params) do
      {
        evento: {
          titulo: "Culto da Família",
          organizacao: "Igreja Y",
          data_evento: (5.days.from_now).strftime("%Y-%m-%dT%H:%M"),
          local: "Rua B, 200",
          cidade: "Rio de Janeiro",
          descricao: "Encontro",
          perfil_divulgacao: "@igreja_y",
          contato_publico: "contato@igreja.y",
          valor: "Entrada Franca"
        },
        banner: banner
      }
    end

    it "cria um evento pendente" do
      expect {
        post submissoes_path, params: params
      }.to change(Evento, :count).by(1)

      expect(response).to redirect_to(nova_submissao_path)
      expect(Evento.last.situacao).to eq("pendente")
    end

    it "não cria evento sem banner" do
      expect {
        post submissoes_path, params: params.except(:banner)
      }.not_to change(Evento, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
