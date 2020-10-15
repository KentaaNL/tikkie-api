# frozen_string_literal: true

module Tikkie
  module Api
    module Clients
      # Base class for all clients.
      class Base
        attr_reader :config

        def initialize(config)
          @config = config
        end
      end
    end
  end
end
