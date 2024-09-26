# frozen_string_literal: true

require 'icalendar'
require 'open-uri'

# .ics Datei laden
ics_file = URI.open('https://swgohevents.com/ical')

# Kalender parsen
calendars = Icalendar::Calendar.parse(ics_file)

# Alle Events durchlaufen
calendars.each do |calendar|
  calendar.events.each do |event|
    if event.summary.include?('TW') || event.summary.include?('TB')
      puts "Event: #{event.summary}"
      puts "Startzeit: #{event.dtstart}"
      puts "Endzeit: #{event.dtend}"
      puts "Beschreibung: #{event.description}"
    end
  end
end