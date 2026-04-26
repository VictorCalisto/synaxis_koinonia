class Views::Validador::Eventos::Show < Views::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::FormWith

  def initialize(evento:)
    @evento = evento
  end

  def view_template
    render(Components::Layouts::Painel.new(titulo: @evento.titulo)) do
      div(class: "mb-4") do
        link_to "← Voltar à fila", validador_eventos_path, class: "text-sm text-gray-500 hover:underline"
      end

      div(class: "bg-white p-6 rounded-lg shadow-sm border border-gray-100 grid md:grid-cols-3 gap-6") do
        div(class: "md:col-span-1") do
          img(src: "/#{@evento.caminho_banner}", alt: "Banner", class: "w-full aspect-square object-cover rounded")
        end
        div(class: "md:col-span-2 space-y-3") do
          h1(class: "text-2xl font-semibold") { @evento.titulo }
          p(class: "text-gray-600") { @evento.organizacao }
          p { strong { "Data: " }; plain localize(@evento.data_evento, format: :long) }
          p { strong { "Local: " }; plain "#{@evento.local} — #{@evento.cidade}" }
          p { strong { "Contato: " }; plain @evento.contato_publico }
          p { strong { "Perfil: " }; plain @evento.perfil_divulgacao }
          p { strong { "Valor: " }; plain @evento.valor }
          div(class: "pt-3 whitespace-pre-line text-gray-800") { @evento.descricao }
        end
      end

      div(class: "flex gap-3 mt-6") do
        link_to "Editar", edit_validador_evento_path(@evento),
                class: "px-4 py-2 bg-gray-100 rounded hover:bg-gray-200"
        if @evento.pendente?
          button_to "Aprovar", aprovar_validador_evento_path(@evento), method: :post,
                    class: "px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700"
        end
      end

      if @evento.pendente?
        section(id: "reprovar", class: "mt-8 bg-white p-6 rounded-lg border border-red-200") do
          h2(class: "text-lg font-semibold text-red-700 mb-3") { "Reprovar evento" }
          form_with(url: reprovar_validador_evento_path(@evento), method: :post) do |f|
            label(for: "motivo_rejeicao", class: "block text-sm font-medium mb-1") { "Motivo (enviado por email se o submissor informou)" }
            f.text_area :motivo_rejeicao, rows: 3,
                        class: "block w-full rounded border border-gray-300 px-3 py-2"
            div(class: "pt-3") do
              f.submit "Reprovar", class: "px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
            end
          end
        end
      end
    end
  end
end
