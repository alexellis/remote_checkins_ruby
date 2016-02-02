require "redis"
require "./lib/repository"

repository = Repository.new
repository.connect("localhost", 6379)

repository.set_checkin(:host_name => "RPi", :timestamp => (Time.new("2016-01-27")) )
repository.set_checkin(:host_name => "RPi_sensor", :timestamp => (Time.new(2016, 1, 28)) )

val1 = repository.get_checkin(:host_name => "RPi")
puts "#{val1}"

val2 = repository.get_checkin(:host_name => "RPi_sensor")
puts "#{val2}"
puts "-----"
puts repository.get_expired_hosts(:now => Time.now, :minutes=> 44546)
