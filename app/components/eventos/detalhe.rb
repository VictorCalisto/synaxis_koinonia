class Components::Eventos::Detalhe < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::L

  def initialize(evento:, url_voltar: nil, url_calendario: nil)
    @evento = evento
    @url_voltar = url_voltar
    @url_calendario = url_calendario
  end

  def view_template
    div(class: "bg-white rounded-lg border border-gray-200 p-6") do
      if @evento.caminho_banner.present?
        img(
          src: "/#{@evento.caminho_banner}",
          alt: @evento.titulo,
          class: "w-full max-h-96 object-cover rounded mb-4"
        )
      end

      h1(class: "text-3xl font-bold mb-2") { @evento.titulo }
      p(class: "text-gray-600 mb-4") { @evento.organizacao }

      div(class: "grid grid-cols-2 gap-4 mb-6") do
        div do
          p(class: "text-sm text-gray-500 mb-1") { "Data e hora" }
          p(class: "font-semibold") { l(@evento.data_evento, format: :long) }
        end
        div do
          p(class: "text-sm text-gray-500 mb-1") { "Local" }
          p(class: "font-semibold") { @evento.local }
        end
        div do
          p(class: "text-sm text-gray-500 mb-1") { "Cidade" }
          p(class: "font-semibold") { @evento.cidade }
        end
        div do
          p(class: "text-sm text-gray-500 mb-1") { "Valor" }
          p(class: "font-semibold") { @evento.valor }
        end
      end

      div(class: "mb-6") do
        h2(class: "text-xl font-semibold mb-2") { "Descrição" }
        p(class: "text-gray-700 whitespace-pre-wrap") { @evento.descricao }
      end

      div(class: "mb-6") do
        h2(class: "text-xl font-semibold mb-2") { "Contato" }
        p(class: "text-gray-700") { @evento.contato_publico }
      end

      div(class: "mb-6") do
        h2(class: "text-xl font-semibold mb-2") { "Redes sociais" }
        div(class: "flex gap-2") do
          a(
            href: "https://instagram.com/#{@evento.perfil_divulgacao.delete('@')}",
            target: "_blank",
            rel: "noopener",
            class: "px-3 py-2 bg-pink-600 text-white rounded hover:bg-pink-700 text-sm"
          ) { "Instagram" }
        end
      end

      div(class: "flex gap-2") do
        link_to "← Voltar", @url_voltar, class: "px-4 py-2 text-blue-600 hover:text-blue-800"
        link_to "📅 Adicionar ao calendário", @url_calendario, class: "px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
      end
    end
  end
end
