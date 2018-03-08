require 'pact/message/consumer/dsl'
require 'pact/message/consumer/configuration/configuration_extensions'
Pact.send(:extend, Pact::Message::Consumer::DSL)
Pact::Configuration.send(:include, Pact::Message::Consumer::Configuration::ConfigurationExtensions)