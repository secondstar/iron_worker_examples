require 'sinatra'
require 'iron_cache'
require 'iron_worker_ng'
require 'twilio-ruby'
use Rack::Logger

helpers do
  def puts(msg)
    request.logger.info msg
  end
end

get '/' do
  erb :index
end

get '/start' do
  number = params[:number]

  config = YAML.load_file("config/config.yml")
  worker_client = IronWorkerNG::Client.new(:token => config['iron']['token'], :project_id => config['iron']['project_id'])
  cache_client = IronCache::Client.new(:token => config['iron']['token'], :project_id => config['iron']['project_id'])
  cache = cache_client.cache("insanity-#{number}")

  load_schedule(cache)
  cache.put("day", 0)

  worker_client.schedules.create('SendInsanity',
                                 {
                                   :number => number
                                 },
                                 {
                                   :start_at => Time.now,
                                   :run_times => 60,
                                   :run_every => 3600*24
                                 })

  redirect '/done'
end

get '/done' do
  erb :done
end


private


def load_schedule(cache)
  puts "Loading Cache Up...."
  i=0
  File.open('lists/insanity_schedule.txt', 'r') do |f|
    while line = f.gets
      cache.put(i.to_s, line)
      i+=1
    end
  end
end


