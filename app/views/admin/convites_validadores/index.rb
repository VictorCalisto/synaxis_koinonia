class Views::Admin::ConvitesValidadores::Index < Views::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(convites:)
    @convites = convites
  end

  def view_template
    render(Components::Layouts::Painel.new(titulo: "Convites", perfil: :admin)) do
      h1(class: "text-2xl font-semibold mb-4") { "Convidar novo validador" }

      form_with(url: admin_convites_validadores_path, method: :post,
                class: "bg-white p-4 rounded-lg border border-gray-100 shadow-sm flex gap-3 items-end max-w-xl") do |f|
        div(class: "flex-1") do
          f.label "convite[email]", "Email", class: "block text-sm font-medium mb-1"
          f.email_field "convite[email]", placeholder: "pessoa@igreja.com",
                        class: "block w-full rounded border border-gray-300 px-3 py-2"
        end
        f.submit "Convidar",
                  class: "px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
      end

      h2(class: "text-lg font-semibold mt-8 mb-2") { "Convites pendentes" }
      if @convites.empty?
        p(class: "text-gray-500 text-sm") { "Nenhum convite ativo no momento." }
      else
        table(class: "w-full bg-white rounded-lg border border-gray-100 shadow-sm") do
          thead(class: "bg-gray-50 text-xs uppercase text-gray-500") do
            tr do
              th(class: "px-4 py-2 text-left") { "Email" }
              th(class: "px-4 py-2 text-left") { "Expira em" }
              th(class: "px-4 py-2 text-right") { "" }
            end
          end
          tbody do
            @convites.each do |c|
              tr(class: "border-t") do
                td(class: "px-4 py-2 text-sm") { c.email }
                td(class: "px-4 py-2 text-sm") { localize(c.expira_em, format: :default) }
                td(class: "px-4 py-2 text-right") do
                  button_to "Cancelar", admin_convite_validador_path(c), method: :delete,
                             data: { turbo_confirm: "Cancelar convite?" },
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
