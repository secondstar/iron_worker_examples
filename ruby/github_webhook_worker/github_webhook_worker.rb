require 'iron_worker'

# bump..
class GithubWebhookWorker < IronWorker::Base

  def run

    puts "hello webhook!  payload: #{IronWorker.payload}"

    #puts 'search=' + twitter_search.inspect
    #results = JSON.parse(twitter_search)


  end

end
