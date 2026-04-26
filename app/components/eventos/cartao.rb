class Components::Eventos::Cartao < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::L

  def initialize(evento:, url_detalhes: nil, url_calendario: nil)
    @evento = evento
    @url_detalhes = url_detalhes
    @url_calendario = url_calendario
  end

  def view_template
    div(class: "bg-white rounded-lg border border-gray-200 shadow-sm hover:shadow-md transition-shadow p-4") do
      if @evento.caminho_banner.present?
        img(
          src: "/#{@evento.caminho_banner}",
          alt: @evento.titulo,
          class: "w-full h-40 object-cover rounded mb-3"
        )
      end

      h3(class: "text-lg font-semibold mb-1 text-gray-900") { @evento.titulo }
      p(class: "text-sm text-gray-600 mb-2") { @evento.organizacao }

      div(class: "flex items-center gap-2 text-sm text-gray-500 mb-2") do
        span { "📅 " }
        span { l(@evento.data_evento, format: :long) }
      end

      div(class: "flex items-center gap-2 text-sm text-gray-500 mb-3") do
        span { "📍 " }
        span { @evento.cidade }
      end

      div(class: "flex gap-2") do
        link_to "Ver detalhes", @url_detalhes, class: "flex-1 px-3 py-2 text-center bg-blue-600 text-white rounded text-sm hover:bg-blue-700 transition"
        link_to "📅", @url_calendario, class: "px-3 py-2 bg-gray-100 rounded hover:bg-gray-200 transition", title: "Adicionar ao calendário"
      end
    end
  end
end
