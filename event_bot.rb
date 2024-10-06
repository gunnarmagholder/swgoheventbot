# frozen_string_literal: true

require 'icalendar'
require 'open-uri'
require 'dotenv/load'
require 'discordrb'
require 'rufus-scheduler'
require 'sqlite3'


# .ics Datei laden
ics_file = URI.open('https://swgohevents.com/ical')

# Kalender parsen
calendars = Icalendar::Calendar.parse(ics_file)

Dotenv.load
BOT_TOKEN = ENV['BOT_TOKEN']
CLIENT_ID = ENV['CLIENT_ID']
CHANNEL_ID = ENV['CHANNEL_ID'].to_i
bot = Discordrb::Bot.new token: BOT_TOKEN, client_id: CLIENT_ID
bot.send_message(CHANNEL_ID, "Bot gestartet.")

# SQLite3 Datenbank initialisieren
db_file = "events.db" 

# Wenn die Datenbank noch nicht existiert, erstelle sie und die Tabelle
unless File.exist?(db_file)
  db = SQLite3::Database.new db_file
  db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS events (
      id INTEGER PRIMARY KEY,
      name TEXT,
      start_date TEXT,
      end_date TEXT,
      UNIQUE(name, start_date) -- Sorgt dafür, dass das Event nur einmal vorkommt
    );
  SQL
else
  db = SQLite3::Database.new db_file
end

scheduler = Rufus::Scheduler.new
scheduler.cron '0 0 * * *' do
  message = "Hier sind die Events für heute:\n"
  # Alle Events durchlaufen
  calendars.each do |calendar|
    calendar.events.each do |event|
      if event.summary.include?('TW') || event.summary.include?('TB')
        message += "Event: #{event.summary}\n"
        message += "Startzeit: #{event.dtstart}\n"
        message += "Endzeit: #{event.dtend}\n"
        message += "Beschreibung: #{event.description}\n"
      end
    end
  end
  bot.send_message(CHANNEL_ID, message)
end

bot.run
