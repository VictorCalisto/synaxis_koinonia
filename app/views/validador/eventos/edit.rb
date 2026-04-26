class Views::Validador::Eventos::Edit < Views::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::LinkTo

  def initialize(evento:)
    @evento = evento
  end

  def view_template
    render(Components::Layouts::Painel.new(titulo: "Editar evento")) do
      div(class: "mb-4") do
        link_to "← Cancelar", validador_evento_path(@evento), class: "text-sm text-gray-500 hover:underline"
      end

      h1(class: "text-2xl font-semibold mb-4") { "Editar evento" }

      if @evento.errors.any?
        div(class: "mb-4 p-3 rounded bg-red-50 border border-red-200 text-red-800 text-sm") do
          ul(class: "list-disc ml-5") { @evento.errors.full_messages.each { |m| li { m } } }
        end
      end

      form_with(model: @evento, url: validador_evento_path(@evento), method: :patch,
                class: "space-y-4 bg-white p-6 rounded-lg shadow-sm border border-gray-100") do |f|
        [
          [:titulo, "Título"],
          [:organizacao, "Igreja/Organização"],
          [:data_evento, "Data e horário", "datetime-local"],
          [:local, "Local"],
          [:cidade, "Cidade"],
          [:perfil_divulgacao, "Perfil"],
          [:contato_publico, "Contato público"],
          [:valor, "Valor"]
        ].each do |nome, rotulo, tipo|
          div do
            f.label nome, rotulo, class: "block text-sm font-medium text-gray-700 mb-1"
            f.text_field nome, type: tipo || "text",
                          class: "block w-full rounded border border-gray-300 px-3 py-2"
          end
        end
        div do
          f.label :descricao, "Descrição", class: "block text-sm font-medium text-gray-700 mb-1"
          f.text_area :descricao, rows: 5, class: "block w-full rounded border border-gray-300 px-3 py-2"
        end
        div(class: "pt-2") do
          f.submit "Salvar", class: "px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
        end
      end
    end
  end
end
