class Views::Publico::Eventos::Show < Views::Base
  include Phlex::Rails::Helpers::Routes

  def initialize(evento:)
    @evento = evento
  end

  def view_template
    render(Components::Layouts::Publico.new) do
      div(class: "container mx-auto px-4 py-8") do
        render(Components::Eventos::Detalhe.new(
          evento: @evento,
          url_voltar: "/",
          url_calendario: "/eventos/#{@evento.id}/calendario.ics"
        ))
      end
    end
  end
end
