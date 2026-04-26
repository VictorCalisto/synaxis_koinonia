class Views::Validador::Eventos::Index < Views::Base
  include Phlex::Rails::Helpers::LinkTo

  def initialize(eventos:, situacao:)
    @eventos = eventos
    @situacao = situacao
  end

  def view_template
    render(Components::Layouts::Painel.new(titulo: "Fila de eventos")) do
      div(class: "flex items-center justify-between mb-4") do
        h1(class: "text-2xl font-semibold") do
          plain "Eventos "
          span(class: "text-gray-500") { t("synaxis.situacao.#{@situacao}") }
        end
        nav(class: "flex gap-2 text-sm") do
          %w[pendente aprovado rejeitado].each do |s|
            link_to t("synaxis.situacao.#{s}"),
                    validador_eventos_path(situacao: s),
                    class: classe_filtro(s)
          end
        end
      end

      if @eventos.empty?
        p(class: "text-gray-500 py-8 text-center") { "Nenhum evento aqui." }
      else
        div(class: "bg-white shadow-sm rounded-lg border border-gray-100 overflow-hidden") do
          table(class: "w-full text-left") do
            thead(class: "bg-gray-50 text-xs uppercase text-gray-500") do
              tr do
                th(class: "px-4 py-2") { "Evento" }
                th(class: "px-4 py-2") { "Data" }
                th(class: "px-4 py-2") { "Cidade" }
                th(class: "px-4 py-2") { "Situação" }
                th(class: "px-4 py-2 text-right") { "Ações" }
              end
            end
            tbody do
              @eventos.each { |e| render Components::Validador::LinhaEvento.new(evento: e) }
            end
          end
        end
      end
    end
  end

  private

  def classe_filtro(situacao)
    base = "px-3 py-1 rounded border"
    if situacao == @situacao
      "#{base} bg-indigo-600 border-indigo-600 text-white"
    else
      "#{base} border-gray-300 text-gray-700 hover:bg-gray-50"
    end
  end
end
