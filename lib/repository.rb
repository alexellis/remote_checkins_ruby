require "redis"
require "time"

class Repository

  def initialize (kvdb: nil)
    @@kvdb = kvdb
  end

  def connect host, port
    @@client = (@@kvdb || Redis.new(:host => host, :port => port))
  end

  def set_checkin (host_name: nil, timestamp: nil)
    @@client.hset("checkins", host_name, timestamp)
  end

  def get_checkin(host_name: nil)
    return @@client.hget("checkins", host_name)
  end

  def get_expired_hosts(now: nil, minutes: nil)
    expired = []
    hosts= @@client.hgetall("checkins")
    hosts.each do |host|
      parsed = Time.parse(host[1])
      diff = (now - parsed) / 60

      if diff > minutes
        expired.push host[0]
      end

    end

    return expired
  end

end
