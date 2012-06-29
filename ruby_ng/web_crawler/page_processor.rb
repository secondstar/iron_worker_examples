require 'net/http'
require 'uri'
require 'open-uri'
require 'hpricot'
require 'iron_cache'
require 'iron_mq'


def process_images(doc)
  #get all images
  images = doc/"img"
  #get image with highest height on page
  largest_image = doc.search("img").sort_by { |img| img["height"].to_i }[-1]
  largest_image = largest_image ? largest_image['src'] : 'none'
  list_of_images = doc.search("img").map { |img| img["src"] }
  return images, largest_image, list_of_images
end

def process_links(doc)
  #get all links
  links = doc/"a"
end

def process_css(doc)
  #find all css includes
  css = doc.search("[@type='text/css']")
end

def process_words(doc)
  #converting to plain text
  text = doc.to_plain_text
  #splitting by words
  words = text.split(/[^a-zA-Z]/)
  #removing empty string
  words.delete_if{|e| e==""}
  #creating hash
  freqs = Hash.new(0)
  #calculating stats
  words.each { |word| freqs[word] += 1 }
  freqs.sort_by {|x,y| y }
end

def process_page(url)
  puts "Processing page #{url}"
  doc = Hpricot(open(url))
  images, largest_image, list_of_images = process_images(doc)
  links = process_links(doc)
  css = process_css(doc)
  words_stat = process_words(doc)
  puts "Number of images on page:#{images.count}"
  puts "Number of css on page:#{css.count}"
  puts "Number of links on page:#{images.count}"
  puts "Largest image on page:#{largest_image}"
  puts "Words frequency:#{words_stat.inspect}"
  #putting all in cache
  @iron_cache_client.items.put(CGI::escape(url), {:status => "processed",
                                                  :number_of_images => images.count,
                                                  :largest_image => CGI::escape(largest_image),
                                                  :number_of_css => css.count,
                                                  :number_of_links => links.count,
                                                  :list_of_images => list_of_images,
                                                  :words_stat => words_stat}.to_json)

end

def get_list_of_urls
  #100 pages per worker at max
  max_number_of_urls = 100
  urls = []
  n = 0
  while n < max_number_of_urls
    puts "Gettig message from IronMQ"
    msg = @iron_mq_client.messages.get()
    puts "Got message from queue - #{msg.inspect}"
    break unless msg
    puts "Adding #{msg.body} to list of urls"
    urls << msg.body
    puts "Deleting message from queue"
    msg.delete
    n+=1
  end
  urls
end


#initializing IW an Iron Cache
@iron_cache_client = IronCache::Client.new({"token" => params['iw_token'], "project_id" => params['iw_project_id']})
@iron_mq_client = IronMQ::Client.new(:token => params['iw_token'], :project_id => params['iw_project_id'])

#getting list of urls
urls = get_list_of_urls

#processing each url
urls.each do |url|
  process_page(CGI::unescape(url))
end
