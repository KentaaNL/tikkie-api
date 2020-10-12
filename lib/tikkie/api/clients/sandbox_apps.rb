# frozen_string_literal: true

module Tikkie
  module Api
    module Clients
      # Sandbox App endpoint at Tikkie.
      class SandboxApps < Base
        def create(attributes = {}, options = {})
          payment = Tikkie::Api::Resources::SandboxApp.new(config, options)
          payment.save(attributes)
        end
      end
    end
  end
end
