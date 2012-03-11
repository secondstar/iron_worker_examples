require 'iron_worker'

class WorkerWithAirbrake < IronWorker::Base

  attr_accessor :api_key

  merge_gem 'airbrake'

  def run
    begin
      Airbrake.configure do |config|
        config.api_key = api_key
      end
      #--- YOUR WORKER CODE BELOW HERE ---




    rescue => ex
      Airbrake.notify(
        :error_class => "#{self.class}",
        :error_message => "#{ex} - #{ex.backtrace}"
      )
      puts "Error sent to Airbrake."
      raise ex
    end
  end
end