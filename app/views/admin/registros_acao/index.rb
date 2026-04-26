class Views::Admin::RegistrosAcao::Index < Views::Base
  include Phlex::Rails::Helpers::FormWith

  def initialize(registros:, filtros:)
    @registros = registros
    @filtros = filtros
  end

  def view_template
    render(Components::Layouts::Painel.new(titulo: "Logs", perfil: :admin)) do
      h1(class: "text-2xl font-semibold mb-4") { "Log de ações" }

      form_with(url: admin_registros_acao_path, method: :get,
                class: "flex gap-3 mb-4 items-end") do |f|
        select_field(f, :acao,      RegistroAcao::ACOES,     "Ação")
        select_field(f, :tipo_ator, RegistroAcao::TIPOS_ATOR, "Tipo de ator")
        f.submit "Filtrar", class: "px-4 py-2 bg-gray-100 rounded hover:bg-gray-200"
      end

      if @registros.empty?
        p(class: "text-gray-500 text-sm") { "Sem registros." }
      else
        table(class: "w-full bg-white rounded-lg border border-gray-100 shadow-sm text-sm") do
          thead(class: "bg-gray-50 text-xs uppercase text-gray-500") do
            tr do
              [ "Quando", "Ator", "Ação", "Evento", "Detalhes" ].each { |h| th(class: "px-3 py-2 text-left") { h } }
            end
          end
          tbody do
            @registros.each do |r|
              tr(class: "border-t") do
                td(class: "px-3 py-2") { localize(r.created_at, format: :default) }
                td(class: "px-3 py-2") { "#{r.tipo_ator} #{r.ator_email}".strip }
                td(class: "px-3 py-2") { r.acao }
                td(class: "px-3 py-2") { r.evento_id&.to_s || "—" }
                td(class: "px-3 py-2 text-xs text-gray-600") { r.detalhes.to_json }
              end
            end
          end
        end
      end
    end
  end

  private

  def select_field(f, nome, opcoes, rotulo)
    div do
      f.label nome, rotulo, class: "block text-xs text-gray-500 mb-1"
      f.select nome, [["Todos", nil]] + opcoes.map { |o| [o, o] },
               { selected: @filtros[nome] },
               class: "rounded border border-gray-300 px-3 py-1.5 text-sm"
    end
  end
end
