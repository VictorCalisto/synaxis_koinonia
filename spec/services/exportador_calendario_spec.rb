require "rails_helper"

RSpec.describe ExportadorCalendario do
  let(:evento) { create(:evento, titulo: "Conferência", descricao: "Uma conferência importante") }

  it "gera .ics válido" do
    ics = ExportadorCalendario.call(evento)

    expect(ics).to include("BEGIN:VCALENDAR")
    expect(ics).to include("END:VCALENDAR")
    expect(ics).to include("SUMMARY:Conferência")
    expect(ics).to include("DESCRIPTION:Uma conferência importante")
    expect(ics).to include("LOCATION:")
  end

  it "inclui URL do evento" do
    ics = ExportadorCalendario.call(evento)
    expect(ics).to include("#{evento.id}@synaxis-koinonia.local")
  end
end
