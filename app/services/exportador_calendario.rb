require "icalendar"

class ExportadorCalendario
  def self.call(evento)
    new(evento).gerar
  end

  def initialize(evento)
    @evento = evento
  end

  def gerar
    calendar = Icalendar::Calendar.new
    calendar.prodid = "-//Synaxis Koinonia//NONSGML v1.0//EN"
    calendar.version = "2.0"

    event = Icalendar::Event.new
    event.dtstart = @evento.data_evento
    event.dtend = @evento.data_evento + 2.hours
    event.summary = @evento.titulo
    event.description = @evento.descricao
    event.location = @evento.local
    event.url = evento_url
    event.uid = "#{@evento.id}@synaxis-koinonia.local"

    calendar.add_event(event)
    calendar.to_ical
  end

  private

  def evento_url
    "#{ENV['APP_HOST']}/eventos/#{@evento.id}"
  end
end
