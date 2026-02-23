# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      # Access token that can be used to make API calls.
      class AccessToken
        attr_accessor :token

        def initialize(token, expires_in)
          @token = token
          @expires_at = Time.now + expires_in.to_i
        end

        def expired?
          Time.now >= @expires_at
        end
      end
    end
  end
end
