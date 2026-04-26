class Views::Publico::Eventos::Index < Views::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::Routes

  def initialize(eventos:, cidade: nil)
    @eventos = eventos
    @cidade = cidade
  end

  def view_template
    render(Components::Layouts::Publico.new) do
      div(class: "container mx-auto px-4 py-8") do
        div(class: "mb-8") do
          h1(class: "text-4xl font-bold mb-4") { "Eventos" }

          div(class: "bg-white p-4 rounded-lg border border-gray-200 mb-6") do
            form_with url: root_path, method: :get, local: true do |f|
              div(class: "flex gap-4") do
                f.text_field :cidade, placeholder: "Filtrar por cidade", value: @cidade, class: "px-4 py-2 border border-gray-300 rounded flex-1"
                f.submit "Filtrar", class: "px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
              end
            end
          end
        end

        if @eventos.any?
          div(class: "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4") do
            @eventos.each do |evento|
              render(Components::Eventos::Cartao.new(
                evento: evento,
                url_detalhes: "/eventos/#{evento.id}",
                url_calendario: "/eventos/#{evento.id}/calendario.ics"
              ))
            end
          end
        else
          div(class: "bg-yellow-50 border border-yellow-200 rounded-lg p-4 text-center") do
            p(class: "text-gray-600") { "Nenhum evento encontrado para a data/cidade selecionada." }
          end
        end
      end
    end
  end
end
