# frozen_string_literal: true
module Pronto
  # Patch the client so it doesn't verify SSL identity
  class Github
    old_client = instance_method(:client)
    define_method(:client) do
      @client = old_client.bind(self).call
      @client.connection_options[:ssl] = { :verify => false }
      @client
    end
  end
end
