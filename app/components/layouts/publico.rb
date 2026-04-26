class Components::Layouts::Publico < Components::Base
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::CSPMetaTag
  include Phlex::Rails::Helpers::StylesheetLinkTag
  include Phlex::Rails::Helpers::JavascriptImportmapTags
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::FlashAlert if false # placeholder

  def initialize(titulo: "Synaxis Koinonia")
    @titulo = titulo
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
      body(class: "min-h-screen bg-gray-50 text-gray-900") do
        render Components::Comuns::BarraNavegacao.new
        main(class: "container mx-auto px-4 py-8") do
          render Components::Comuns::Alertas.new(flash: view_context.flash)
          yield
        end
        render Components::Comuns::Rodape.new
      end
    end
  end
end
