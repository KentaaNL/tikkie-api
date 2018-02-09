# frozen_string_literal: true

require 'json'
require 'jwt'
require 'net/http'
require 'uri'

module Tikkie
  module Api
    # Provides authentication for the ABN AMRO OAuth API.
    # see https://developer.abnamro.com/get-started#authentication
    class Authentication
      def initialize(config)
        @config = config
      end

      def authenticate
        uri = URI.parse(File.join(@config.api_url, "/oauth/token"))

        request = Net::HTTP::Post.new(uri)
        request["Api-Key"] = @config.api_key

        request.set_form_data(
          client_assertion: jwt_token,
          client_assertion_type: "urn:ietf:params:oauth:client-assertion-type:jwt-bearer",
          grant_type: "client_credentials",
          scope: "tikkie"
        )

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
          http.request(request)
        end

        if response.is_a?(Net::HTTPSuccess)
          json = JSON.parse(response.body, symbolize_names: true)

          Tikkie::Api::AccessToken.new(json[:access_token], json[:expires_in])
        else
          raise Tikkie::Api::AuthenticationException, response
        end
      end

      private

      def jwt_token
        now = Time.now.to_i

        payload = {
          nbf: now - 120,
          exp: now + 120, # Token is valid for 2 minutes
          iss: "Ruby Tikkie client",
          sub: @config.api_key,
          aud: @config.oauth_token_url
        }

        JWT.encode(payload, @config.private_data, @config.jwt_hashing_algorithm, typ: "JWT")
      end
    end
  end
end
