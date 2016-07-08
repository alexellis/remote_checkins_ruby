require "redis"
require "./lib/repository"

Given(/^redis is available$/) do
    @repository = Repository.new
    @redis_port = 6379    

end

When(/^I connect$/) do
  @repository.connect("localhost", @redis_port)
end

Then(/^it does not error$/) do
  @repository.set_checkin(:host_name => "RPi", :timestamp => (Time.new("2016-01-27")))
end

Given(/^redis is not available$/) do
    @repository = Repository.new
    @redis_port = 16379    
end

Then(/^it gives us an error$/) do
    error = nil
    begin
        @repository.set_checkin(:host_name => "RPi", :timestamp => (Time.new("2016-01-27")) )
    rescue Exception => e  
        #puts e.message  
        error = e
    end
    expect(error).not_to eql(nil)
    expect(error.message).to eql("Error connecting to Redis on localhost:16379 (Errno::ECONNREFUSED)")
end
