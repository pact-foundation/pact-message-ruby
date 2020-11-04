require 'spec_helper'

# class TheDataStore


# end

# Pact.provider_states_for "Foo" do



# end

class BarProvider
  def create_message
    {
      text: "Hello world"
    }
  end

end

class AdapterApp

  # def initialize

  # end

  def call(env)
    puts env
    [200, {"Content-Type" => "application/json"}, { contents: BarProvider.new.create_message }]
  end

end




Pact.service_provider "Bar" do
  app { AdapterApp.new }
end