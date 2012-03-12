class PagerdutyWorker < IronWorker::Base
  merge_gem 'httparty'

  attr_accessor :api_key

  def run
    begin
      # Your worker code in here

    rescue => ex
      trigger_alert(ex)
      raise ex
    end
  end


  # Method to hit the PagerDuty "Generic API" trigger
  def trigger_alert(ex)
    payload = {
      "service_key" => api_key,
      "event_type" => "trigger",
      "description" => "#{ex} - #{ex.backtrace}",
    }.to_json
    url = 'https://events.pagerduty.com/generic/2010-04-15/create_event.json'
    resp = HTTParty.post(url, {:body => payload})
  end
end