require "rails_helper"

RSpec.describe "Público::Eventos", type: :request do
  describe "GET /" do
    it "lista apenas eventos aprovados" do
      create(:evento, :aprovado)
      create(:evento, :pendente)
      create(:evento, :rejeitado)

      get root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("grid")
    end

    it "lista eventos futuros em ordem de data" do
      evento1 = create(:evento, :aprovado, data_evento: 3.days.from_now, titulo: "Primeiro")
      evento2 = create(:evento, :aprovado, data_evento: 1.day.from_now, titulo: "Segundo")

      get root_path
      body = response.body
      expect(body.index("Segundo")).to be < body.index("Primeiro")
    end

    context "com filtro de cidade" do
      it "filtra por cidade" do
        create(:evento, :aprovado, cidade: "São Paulo")
        create(:evento, :aprovado, cidade: "Rio de Janeiro")

        get root_path, params: { cidade: "São Paulo" }
        expect(response.body).to include("São Paulo")
        expect(response.body).not_to include("Rio de Janeiro")
      end
    end
  end

  describe "GET /eventos/:id" do
    let(:evento) { create(:evento, :aprovado) }

    it "mostra evento aprovado" do
      get evento_path(evento)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(evento.titulo)
    end

    it "404 para evento não aprovado" do
      evento_pendente = create(:evento, :pendente)
      get evento_path(evento_pendente)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /eventos/:id/calendario.ics" do
    let(:evento) { create(:evento, :aprovado, titulo: "Palestra") }

    it "retorna arquivo .ics" do
      get "/eventos/#{evento.id}/calendario"
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(/text\/calendar/)
      expect(response.body).to include("BEGIN:VCALENDAR")
      expect(response.body).to include("Palestra")
    end
  end
end
