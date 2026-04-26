class Views::EdicoesToken::Show < Views::Base
  def initialize(evento:)
    @evento = evento
  end

  def view_template
    render(Components::Layouts::Publico.new(titulo: "Editar evento")) do
      div(class: "max-w-2xl mx-auto") do
        h1(class: "text-3xl font-bold mb-2") { "Editar evento" }
        p(class: "text-sm text-gray-500 mb-6") do
          plain "O link de edição expira em "
          strong { localize(@evento.token_expira_em, format: :long) }
          plain "."
        end

        if @evento.errors.any?
          div(class: "mb-4 p-3 rounded bg-red-50 border border-red-200 text-red-800 text-sm") do
            ul(class: "list-disc ml-5") do
              @evento.errors.full_messages.each { |msg| li { msg } }
            end
          end
        end

        render Components::Formularios::EdicaoToken.new(evento: @evento)
      end
    end
  end
end
