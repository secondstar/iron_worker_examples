require 'net/http'
require 'uri'
require 'open-uri'
require 'hpricot'
require 'iron_worker_ng'
require 'iron_cache'

load 'url_utils.rb'

include UrlUtils



def process_page(url)
  @icache.items.put(CGI::escape(url), "processed")
  puts "Processing page #{url}"
end

def crawl_domain(url, depth)
  url_object = open_url(url)
  return if url_object == nil
  parsed_url = parse_url(url_object)
  return if parsed_url == nil
  puts "Scanning URL:#{url}"
  page_urls = find_urls_on_page(parsed_url, url)
  puts "FOUND links:#{page_urls.count}"
  page_urls.each_with_index do |page_url,index|
    if urls_on_same_domain?(url, page_url)
      pages_count = @icache.items.get('pages_count').value || 0
      puts "Pages scanned:#{pages_count}"
      puts "Page url #{page_url},index:#{index}"
      @icache.items.put('pages_count', pages_count + 1)
      return if pages_count >= params['page_limit']
      puts "current depth:#{depth}"
      page_from_cache = @icache.items.get(CGI::escape(page_url))
      if page_from_cache.nil?
        process_page(page_url)
        queue_worker(depth, page_url) if depth > 1
      else
        puts "Link #{page_url} already processed, bypassing"
        #page_from_cache.delete
      end
    end
  end
end

def queue_worker(depth, page_url)
  workers_count = @icache.items.get('workers_count')
  count = workers_count ? workers_count.value : 0
  puts "Number of workers:#{count}"
  if count < params['max_workers'] - 1
    @icache.items.put('workers_count', count+1)
    p = {:url => page_url,
              :page_limit => params["page_limit"],
              :depth => depth - 1,
              :max_workers => params["max_workers"],
              :iw_token => params["iw_token"],
              :iw_project_id => params["iw_project_id"]
    }
    @client.tasks.create("WebCrawler", p)
  else
    crawl_domain(page_url, depth-1)
  end
end

private

def open_url(url)
  url_object = nil
  begin
    url_object = open(url)
  rescue
    puts "Unable to open url: " + url
  end
  url_object
end

def update_url_if_redirected(url, url_object)
  if url != url_object.base_uri.to_s
    return url_object.base_uri.to_s
  end
  url
end

def parse_url(url_object)
  doc = nil
  begin
    doc = Hpricot(url_object)
  rescue
    puts 'Could not parse url: ' + url_object.base_uri.to_s
  end
  puts 'Crawling url ' + url_object.base_uri.to_s
  doc
end

def find_urls_on_page(parsed_url, current_url)
  urls_list = []
  begin
    parsed_url.search('a[@href]').map do |x|
      new_url = x['href'].split('#')[0]
      unless new_url == nil
        if relative?(new_url)
          new_url = make_absolute(current_url, new_url)
        end
        urls_list.push(new_url)
      end
    end
  rescue
    puts "could not find links"
  end
  urls_list
end

@icache = IronCache::Client.new({"token" => params['iw_token'], "project_id" => params['iw_project_id']})
@client = IronWorkerNG::Client.new(:token => params['iw_token'], :project_id => params['iw_project_id'])

crawl_domain(params['url'], params['depth']||1)

workers_count = @icache.items.get('workers_count')
count = workers_count ? workers_count.value : 0

@icache.items.put('workers_count', count-1) if count > 0