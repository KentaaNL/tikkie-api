# frozen_string_literal: true

module Tikkie
  module Api
    module Resources
      # Resource for a Sandbox App.
      class SandboxApp < Base
        def app_token
          body[:appToken]
        end

        private

        def create_resource(attributes)
          request.post("sandboxapps", options, attributes)
        end
      end
    end
  end
end
