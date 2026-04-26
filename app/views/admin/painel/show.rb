class Views::Admin::Painel::Show < Views::Base
  include Phlex::Rails::Helpers::LinkTo

  def initialize(resumo:)
    @resumo = resumo
  end

  def view_template
    render(Components::Layouts::Painel.new(titulo: "Painel admin", perfil: :admin)) do
      h1(class: "text-2xl font-semibold mb-6") { "Painel" }
      div(class: "grid md:grid-cols-4 gap-4") do
        cartao("Eventos pendentes", @resumo[:pendentes])
        cartao("Eventos aprovados", @resumo[:aprovados])
        cartao("Validadores",       @resumo[:validadores])
        cartao("Convites pendentes", @resumo[:convites_pendentes])
      end
    end
  end

  private

  def cartao(rotulo, valor)
    div(class: "bg-white p-4 rounded-lg border border-gray-100 shadow-sm") do
      div(class: "text-sm text-gray-500") { rotulo }
      div(class: "text-3xl font-semibold mt-1") { valor.to_s }
    end
  end
end
