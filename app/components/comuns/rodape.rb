class Components::Comuns::Rodape < Components::Base
  def view_template
    footer(class: "border-t border-gray-200 mt-12 py-6 text-center text-sm text-gray-500") do
      plain "Synaxis Koinonia · agenda eclesiástica comunitária"
    end
  end
end
