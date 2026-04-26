class Views::Submissoes::New < Views::Base
  def initialize(evento:)
    @evento = evento
  end

  def view_template
    render(Components::Layouts::Publico.new(titulo: "Enviar evento")) do
      div(class: "max-w-2xl mx-auto") do
        h1(class: "text-3xl font-bold mb-4") { t("synaxis.submissao.titulo") }
        p(class: "text-gray-600 mb-6") { t("synaxis.submissao.instrucoes") }

        if @evento.errors.any?
          div(class: "mb-4 p-3 rounded bg-red-50 border border-red-200 text-red-800 text-sm") do
            ul(class: "list-disc ml-5") do
              @evento.errors.full_messages.each { |msg| li { msg } }
            end
          end
        end

        render Components::Formularios::Submissao.new(evento: @evento)
      end
    end
  end
end
