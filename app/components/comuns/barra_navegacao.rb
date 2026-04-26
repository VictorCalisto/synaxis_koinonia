class Components::Comuns::BarraNavegacao < Components::Base
  include Phlex::Rails::Helpers::LinkTo

  def view_template
    header(class: "bg-white border-b border-gray-200") do
      div(class: "container mx-auto px-4 py-4 flex items-center justify-between") do
        link_to "Synaxis Koinonia", root_path, class: "text-xl font-semibold text-indigo-700"
        nav(class: "space-x-4 text-sm") do
          link_to "Eventos", root_path, class: "hover:underline"
          link_to "Divulgar evento", nova_submissao_path, class: "hover:underline"
        end
      end
    end
  end
end
