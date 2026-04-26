class Views::ConvitesValidadores::Show < Views::Base
  include Phlex::Rails::Helpers::FormWith

  def initialize(convite:)
    @convite = convite
  end

  def view_template
    render(Components::Layouts::Publico.new(titulo: "Aceitar convite")) do
      div(class: "max-w-md mx-auto bg-white p-6 rounded-lg shadow-sm border border-gray-100") do
        h1(class: "text-2xl font-semibold mb-2") { "Convite para validador" }
        p(class: "text-sm text-gray-600 mb-4") do
          plain "Definindo senha para "
          strong { @convite.email }
          plain "."
        end

        form_with(url: confirmar_convite_path(@convite.token), method: :patch, class: "space-y-4") do |f|
          f.fields_for :convite, OpenStruct.new do |ff|
            div do
              ff.label :senha, "Senha", class: "block text-sm font-medium mb-1"
              ff.password_field :senha, class: "block w-full rounded border border-gray-300 px-3 py-2"
            end
            div do
              ff.label :senha_confirmacao, "Confirmar senha", class: "block text-sm font-medium mb-1"
              ff.password_field :senha_confirmacao, class: "block w-full rounded border border-gray-300 px-3 py-2"
            end
          end
          f.submit "Criar conta",
                    class: "w-full px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
        end
      end
    end
  end
end
