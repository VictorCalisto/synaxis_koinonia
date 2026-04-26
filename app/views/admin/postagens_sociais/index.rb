class Views::Admin::PostagensSociais::Index < Views::Base
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(evento:, postagens:)
    @evento = evento
    @postagens = postagens
  end

  def view_template
    render(Components::Layouts::Painel.new(titulo: "Postagens sociais", perfil: :admin)) do
      h1(class: "text-2xl font-semibold mb-1") { "Postagens do evento" }
      p(class: "text-gray-600 mb-4") { @evento.titulo }

      if @postagens.empty?
        p(class: "text-gray-500 text-sm") { "Nenhuma postagem registrada para este evento." }
      else
        div(class: "bg-white rounded-lg border border-gray-100 shadow-sm divide-y") do
          @postagens.each do |p|
            div(class: "p-4 flex items-center justify-between") do
              div do
                div(class: "text-sm font-medium") { p.plataforma.titleize }
                div(class: "text-xs text-gray-500") { p.url_externa || "—" }
              end
              div(class: "flex gap-2") do
                button_to "Atualizar",
                          admin_evento_postagem_social_path(@evento, p),
                          method: :patch,
                          class: "text-sm px-3 py-1 bg-indigo-50 text-indigo-700 rounded"
                button_to "Remover",
                          admin_evento_postagem_social_path(@evento, p),
                          method: :delete,
                          data: { turbo_confirm: "Remover esta postagem?" },
                          class: "text-sm px-3 py-1 bg-red-50 text-red-700 rounded"
              end
            end
          end
        end
      end
    end
  end
end
