class Components::Validador::LinhaEvento < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(evento:)
    @evento = evento
  end

  def view_template
    tr(class: "border-t border-gray-200") do
      td(class: "px-4 py-3") do
        link_to @evento.titulo, validador_evento_path(@evento),
                class: "text-indigo-700 hover:underline font-medium"
        div(class: "text-xs text-gray-500") { @evento.organizacao }
      end
      td(class: "px-4 py-3 text-sm") { localize(@evento.data_evento, format: :default) }
      td(class: "px-4 py-3 text-sm") { @evento.cidade }
      td(class: "px-4 py-3 text-sm") do
        span(class: classe_situacao) { t("synaxis.situacao.#{@evento.situacao}") }
      end
      td(class: "px-4 py-3 text-right") do
        link_to "Editar", edit_validador_evento_path(@evento),
                class: "text-sm text-gray-700 hover:underline"
        if @evento.pendente?
          plain " · "
          button_to "Aprovar", aprovar_validador_evento_path(@evento), method: :post,
                   class: "text-sm text-green-700 hover:underline inline"
          plain " · "
          link_to "Reprovar", validador_evento_path(@evento, anchor: "reprovar"),
                  class: "text-sm text-red-700 hover:underline"
        end
      end
    end
  end

  private

  def classe_situacao
    base = "inline-block px-2 py-0.5 rounded text-xs font-medium"
    case @evento.situacao
    when "pendente"  then "#{base} bg-yellow-100 text-yellow-800"
    when "aprovado"  then "#{base} bg-green-100 text-green-800"
    when "rejeitado" then "#{base} bg-red-100 text-red-800"
    end
  end
end
