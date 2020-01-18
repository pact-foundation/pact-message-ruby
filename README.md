# Pact::Message

[![Join the chat at https://gitter.im/pact-foundation/pact-message-ruby](https://badges.gitter.im/pact-foundation/pact-message-ruby.svg)](https://gitter.im/pact-foundation/pact-message-ruby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Create and verify consumer driven contracts for messages.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pact'
gem 'pact-message'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pact
    $ gem install pact-message

## Usage

The key to using Message Pact is to completely separate the business logic that creates the message from the transmission protocol (eg. Kafka, Websockets, Lambda). This allows you to write a contract for the message contents, no matter how it is communicated.

### Consumer

Not finished yet as nobody has asked for it. Ping @Beth Skurrie on slack.pact.io if you'd like use this.

### Provider

Also called a "producer". Message pact verification follows all the same principles as HTTP pact verification, except that instead of verifying that a provider can make the expected HTTP response, we are verifying that the provider can create the expected message. Please read the HTTP Pact [verification](https://github.com/pact-foundation/pact-ruby/wiki/Verifying-pacts) documentation. The only difference is in the configuration block. Use `message_provider` instead of `service_provider`, and configure a `builder` block that takes a `|description|` argument, instead of a Rack `app` block.

Make sure you've required 'pact/message' as well as 'pact'.

```ruby
require 'pact'
require 'pact/message'

Pact.message_provider "MyMessageProvider" do
  builder do |description|
    #... code that returns the correct message based on the description goes here
  do
  
  honours_pact_with "MyMessageConsumer" do
    pact_uri "/path/or/url/to/your/pact", { 
                          username: "optional username", 
                          password: "optional password", 
                          token: "optional token"
                        }
  end
  
  # or
  
  honours_pacts_from_pact_broker do
    # See docs at https://github.com/pact-foundation/pact-ruby/wiki/Verifying-pacts
  end
end

```

How you map between the message description and the code that creates the message is up to you. The easiest way is something like this:

```ruby
class MyMessageProvider
  def create_hello_message
    {
      text: "Hello world"
    }
  end
end

CONFIG = {
  "a hello message" => lambda { MyMessageProvider.new.create_hello_message }
}

Pact.message_provider "SomeProvider" do
  builder do |description|
    CONFIG[description].call
  do
end

```

#### Provider states

Provider states work the same way for Message Pact as they do for HTTP Pact. Please read the [provider state](https://github.com/pact-foundation/pact-ruby#using-provider-states) docs in the HTTP Pact project.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pact-foundation/pact-message-ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
