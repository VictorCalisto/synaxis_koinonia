class Components::Formularios::Submissao < Components::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::FieldsFor

  def initialize(evento:)
    @evento = evento
  end

  def view_template
    form_with(model: @evento, url: submissoes_path, method: :post, multipart: true,
              class: "space-y-5 bg-white p-6 rounded-lg shadow-sm border border-gray-100") do |f|
      render_campo(f, :titulo, "Título do evento")
      render_campo(f, :organizacao, "Igreja / Organização")
      render_campo(f, :data_evento, "Data e horário", type: "datetime-local")
      render_campo(f, :local, "Local (endereço completo)")
      render_campo(f, :cidade, "Cidade")
      render_textarea(f, :descricao, "Descrição")
      render_campo(f, :perfil_divulgacao, "Perfil para marcar (@igreja_tal)")
      render_campo(f, :contato_publico, "Contato público (email, telefone ou WhatsApp)")
      render_campo(f, :valor, "Valor (deixe em branco para Entrada Franca)")
      render_campo(f, :email_submissor, "Seu email (opcional — permite edição)", type: "email")

      div do
        label(for: "banner", class: "block text-sm font-medium text-gray-700 mb-1") do
          plain "Banner do evento (quadrado, JPG ou PNG, até 5MB)"
        end
        input(type: "file", name: "banner", id: "banner", accept: "image/jpeg,image/png",
              class: "block w-full text-sm")
      end

      div(class: "pt-2") do
        f.submit "Enviar para avaliação",
                 class: "inline-flex items-center px-4 py-2 bg-indigo-600 text-white text-sm font-medium rounded hover:bg-indigo-700"
      end
    end
  end

  private

  def render_campo(f, atributo, rotulo, type: "text")
    div do
      f.label atributo, rotulo, class: "block text-sm font-medium text-gray-700 mb-1"
      f.text_field atributo, type: type,
                   class: "block w-full rounded border border-gray-300 px-3 py-2 focus:border-indigo-500 focus:ring-indigo-500"
    end
  end

  def render_textarea(f, atributo, rotulo)
    div do
      f.label atributo, rotulo, class: "block text-sm font-medium text-gray-700 mb-1"
      f.text_area atributo, rows: 5,
                  class: "block w-full rounded border border-gray-300 px-3 py-2 focus:border-indigo-500 focus:ring-indigo-500"
    end
  end
end
