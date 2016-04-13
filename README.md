# remote_checkins_ruby
Use Ruby and redis to host a remote checkin service

### The example

Shows how to use Ruby to unit test a sub-system, with dependency injection of a stubbed Redis driver.

* Uses RSpec to define and run unit tests
* main.rb exercises the code using a real Redis driver

### Running the tests:

```
$ gem install rspec
$ rspec spec/*.rb
```

### Running the code:

```
$ gem install redis
$ ruby main.rb
```
