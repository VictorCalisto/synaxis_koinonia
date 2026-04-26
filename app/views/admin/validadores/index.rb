class Views::Admin::Validadores::Index < Views::Base
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(validadores:)
    @validadores = validadores
  end

  def view_template
    render(Components::Layouts::Painel.new(titulo: "Validadores", perfil: :admin)) do
      h1(class: "text-2xl font-semibold mb-4") { "Validadores ativos" }
      if @validadores.empty?
        p(class: "text-gray-500 text-sm") { "Nenhum validador cadastrado ainda." }
      else
        table(class: "w-full bg-white rounded-lg border border-gray-100 shadow-sm") do
          thead(class: "bg-gray-50 text-xs uppercase text-gray-500") do
            tr do
              th(class: "px-4 py-2 text-left") { "Email" }
              th(class: "px-4 py-2 text-left") { "Desde" }
              th(class: "px-4 py-2 text-right") { "" }
            end
          end
          tbody do
            @validadores.each do |v|
              tr(class: "border-t") do
                td(class: "px-4 py-2 text-sm") { v.email }
                td(class: "px-4 py-2 text-sm") { localize(v.created_at, format: :default) }
                td(class: "px-4 py-2 text-right") do
                  button_to "Remover", admin_validador_path(v), method: :delete,
                             data: { turbo_confirm: "Remover validador?" },
                             class: "text-sm text-red-700 hover:underline"
                end
              end
            end
          end
        end
      end
    end
  end
end
