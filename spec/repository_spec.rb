require "../lib/repository"
require "./stub"
require "time"

describe "repository tests" do
  it "connects" do
    repository = Repository.new(:kvdb => Kvdb.new("localhost", "6739"))
    repository.connect "localhost", "6739"
  end

  it "sets host checkin time" do
    repository = Repository.new(:kvdb =>Kvdb.new("localhost", "6739"))
    repository.set_checkin :host_name => "RPi", :timestamp => Time.new
  end

  it "sets and gets a single host checkin time" do
    repository = Repository.new(:kvdb =>Kvdb.new("localhost", "6739"))
    repository.set_checkin :host_name => "RPi", :timestamp => Time.parse("2015-01-27")
    val = repository.get_checkin(:host_name => "RPi")
    expect(val).to eq("2015-01-27 00:00:00 +0000")
  end

  it "sets and gets two separate host checkin times" do
    repository = Repository.new(:kvdb =>Kvdb.new("localhost", "6739"))

    repository.set_checkin(:host_name => "RPi", :timestamp => (Time.new("2016-01-27")) )
    repository.set_checkin(:host_name => "RPi_sensor", :timestamp => (Time.new(2016, 1, 28)) )

    val1 = repository.get_checkin(:host_name => "RPi")
    expect(val1).to eq("2016-01-01 00:00:00 +0000")

    val2 = repository.get_checkin(:host_name => "RPi_sensor")
    expect(val2).to eq("2016-01-28 00:00:00 +0000")
  end

  it "sets then update a single host checkin time" do
    repository = Repository.new(:kvdb =>Kvdb.new("localhost", "6739"))

    repository.set_checkin(:host_name => "RPi", :timestamp => (Time.new(2016,01,27)) )
    repository.set_checkin(:host_name => "RPi", :timestamp => (Time.new(2016,01,28)) )

    val = repository.get_checkin(:host_name => "RPi")
    expect(val).to eq("2016-01-28 00:00:00 +0000")
  end

  describe "expired hosts" do
    it "gets expired hosts, single host expired" do

      repository = Repository.new(:kvdb => Kvdb.new("localhost", "6739"))
      time_then = Time.new(2016,01,27,20,00,00)
      time_now = Time.new(2016,01,27,22,00,00)

      repository.set_checkin(:host_name => "RPi", :timestamp => time_then)

      val = repository.get_expired_hosts(:now=>time_now, :minutes=>60)
      expect(val).to include("RPi")
    end

    it "gets expired hosts, two hosts expired" do

      repository = Repository.new(:kvdb => Kvdb.new("localhost", "6739"))
      time_now = Time.new(2016,01,27,22,00,00)

      repository.set_checkin(:host_name => "RPi", :timestamp =>  Time.new(2016,01,27,20,00,00))
      repository.set_checkin(:host_name => "RPi2", :timestamp =>  Time.new(2016,01,27,20,10,00))

      val = repository.get_expired_hosts(:now=>time_now, :minutes=>60)
      expect(val).to include("RPi")
      expect(val).to include("RPi2")
    end

    it "gets expired hosts, no hosts expired" do

      repository = Repository.new(:kvdb => Kvdb.new("localhost", "6739"))
      time_then = Time.new(2016,01,27,21,30,00)
      time_now = Time.new(2016,01,27,22,00,00)

      repository.set_checkin(:host_name => "RPi", :timestamp => time_then)

      val = repository.get_expired_hosts(:now=>time_now, :minutes=>60)
      expect(val).to be_empty
    end
  end
end
