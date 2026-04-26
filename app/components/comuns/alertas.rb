class Components::Comuns::Alertas < Components::Base
  CLASSES = {
    "notice"  => "bg-green-50 border border-green-200 text-green-800",
    "alert"   => "bg-red-50 border border-red-200 text-red-800",
    "warning" => "bg-amber-50 border border-amber-200 text-amber-800"
  }.freeze

  def initialize(flash:)
    @flash = flash
  end

  def view_template
    return if @flash.blank?

    @flash.each do |tipo, mensagem|
      next if mensagem.blank?

      classe = CLASSES[tipo.to_s] || CLASSES["notice"]
      div(class: "mb-4 px-4 py-3 rounded #{classe}") do
        plain mensagem.to_s
      end
    end
  end
end
