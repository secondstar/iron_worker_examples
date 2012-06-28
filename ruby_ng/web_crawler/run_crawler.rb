require 'iron_worker_ng'
require 'iron_cache'
require "yaml"

config_data = YAML.load_file("../_config.yml")

def params
  {'url' => 'http://iron.io',
   'page_limit' => 1000,
   'depth' => 2,
   'max_workers' => 2,
   'iw_token' => config_data['iw']['iw_token'],
   'iw_project_id' => config_data['iw']['project_id']}
end

client = IronWorkerNG::Client.new(:token => params['iw_token'], :project_id => params['iw_project_id'])
#cleaning up cache
cache = IronCache::Client.new({"token" => params['iw_token'], "project_id" => params['iw_project_id']})
cache.items.put('pages_count', 0)
#launching worker
client.tasks.create("WebCrawler", params)
