class Components::Formularios::EdicaoToken < Components::Base
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(evento:)
    @evento = evento
  end

  def view_template
    form_with(model: @evento, url: edicao_token_path(@evento.token_edicao), method: :patch,
              class: "space-y-5 bg-white p-6 rounded-lg shadow-sm border border-gray-100") do |f|
      render_campo(f, :titulo,            "Título")
      render_campo(f, :organizacao,       "Igreja / Organização")
      render_campo(f, :data_evento,       "Data e horário", type: "datetime-local")
      render_campo(f, :local,             "Local")
      render_campo(f, :cidade,            "Cidade")
      render_textarea(f, :descricao,      "Descrição")
      render_campo(f, :perfil_divulgacao, "Perfil (@)")
      render_campo(f, :contato_publico,   "Contato público")
      render_campo(f, :valor,             "Valor")

      div(class: "flex items-center gap-3 pt-2") do
        f.submit "Salvar alterações",
                 class: "px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
      end
    end

    div(class: "mt-6") do
      button_to "Remover este evento",
                edicao_token_path(@evento.token_edicao),
                method: :delete,
                data: { turbo_confirm: "Remover em definitivo?" },
                class: "px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
    end
  end

  private

  def render_campo(f, atributo, rotulo, type: "text")
    div do
      f.label atributo, rotulo, class: "block text-sm font-medium text-gray-700 mb-1"
      f.text_field atributo, type: type,
                   class: "block w-full rounded border border-gray-300 px-3 py-2"
    end
  end

  def render_textarea(f, atributo, rotulo)
    div do
      f.label atributo, rotulo, class: "block text-sm font-medium text-gray-700 mb-1"
      f.text_area atributo, rows: 5,
                  class: "block w-full rounded border border-gray-300 px-3 py-2"
    end
  end
end
