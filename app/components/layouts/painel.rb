class Components::Layouts::Painel < Components::Base
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::CSPMetaTag
  include Phlex::Rails::Helpers::StylesheetLinkTag
  include Phlex::Rails::Helpers::JavascriptImportmapTags
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(titulo: "Painel", perfil: :validador)
    @titulo = titulo
    @perfil = perfil
  end

  def view_template(&block)
    doctype
    html(lang: "pt-BR") do
      head do
        title { @titulo }
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        csrf_meta_tags
        csp_meta_tag
        stylesheet_link_tag "tailwind", data_turbo_track: "reload"
        javascript_importmap_tags
      end
      body(class: "min-h-screen bg-slate-50 text-gray-900") do
        render_header
        main(class: "container mx-auto px-4 py-8 max-w-6xl") do
          render Components::Comuns::Alertas.new(flash: view_context.flash)
          yield
        end
      end
    end
  end

  private

  def render_header
    header(class: "bg-white border-b border-gray-200") do
      div(class: "container mx-auto px-4 py-4 flex items-center justify-between") do
        div(class: "flex items-center gap-6") do
          link_to "Synaxis Koinonia · #{@perfil.to_s.titleize}",
                  @perfil == :admin ? admin_root_path : validador_eventos_path,
                  class: "text-lg font-semibold text-indigo-700"
          nav(class: "text-sm text-gray-600 space-x-3") { render_nav }
        end
        render_logout
      end
    end
  end

  def render_nav
    if @perfil == :admin
      link_to "Convites",    admin_convites_validadores_path, class: "hover:underline"
      link_to "Validadores", admin_validadores_path,          class: "hover:underline"
      link_to "Logs",        admin_registros_acao_path,       class: "hover:underline"
    else
      link_to "Fila",        validador_eventos_path,                                     class: "hover:underline"
      link_to "Aprovados",   validador_eventos_path(situacao: "aprovado"),               class: "hover:underline"
      link_to "Rejeitados",  validador_eventos_path(situacao: "rejeitado"),              class: "hover:underline"
    end
  end

  def render_logout
    path = @perfil == :admin ? destroy_admin_session_path : destroy_validador_session_path
    button_to "Sair", path, method: :delete,
              class: "text-sm text-gray-600 hover:text-gray-900"
  end
end
