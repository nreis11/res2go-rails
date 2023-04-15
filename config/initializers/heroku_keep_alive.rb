require 'rufus/scheduler'
scheduler = Rufus::Scheduler.new

if Rails.env.production?
  scheduler.cron '*/15 9-21 * * *' do
     url = "https://res2go.onrender.com"
     puts "Pinging #{url}"
     require "net/http"
     require "uri"
     Net::HTTP.get_response(URI.parse(url))
  end
end