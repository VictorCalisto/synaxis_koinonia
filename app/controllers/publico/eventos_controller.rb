module Publico
  class EventosController < ApplicationController
    def index
      cidade = params[:cidade]
      eventos = Evento.aprovados.futuros.order(:data_evento)
      eventos = eventos.por_cidade(cidade) if cidade.present?

      render Views::Publico::Eventos::Index.new(eventos: eventos, cidade: cidade)
    end

    def show
      evento = Evento.aprovados.find(params[:id])
      render Views::Publico::Eventos::Show.new(evento: evento)
    end

    def calendario
      evento = Evento.aprovados.find(params[:id])
      ics = ExportadorCalendario.call(evento)

      send_data ics, filename: "#{evento.titulo.parameterize}.ics", type: "text/calendar"
    end
  end
end
