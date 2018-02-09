# frozen_string_literal: true

module Tikkie
  module Api
    # Tikkie API Configuration. An API Key and private key are mandatory.
    # see https://developer.abnamro.com/get-started
    class Configuration
      SANDBOX_API_URL = "https://api-sandbox.abnamro.com/v1/"
      PRODUCTION_API_URL = "https://api.abnamro.com/v1/"

      SANDBOX_OAUTH_TOKEN_URL = "https://auth-sandbox.abnamro.com/oauth/token"
      PRODUCTION_OAUTH_TOKEN_URL = "https://auth.abnamro.com/oauth/token"

      DEFAULT_HASHING_ALGORITHM = "RS256"
      VALID_HASHING_ALGORITHMS = %w[RS256 RS384 RS512].freeze

      attr_reader :api_key, :private_key, :options

      def initialize(api_key, private_key, options = {})
        @api_key = api_key
        @private_key = private_key
        @options = options
      end

      def private_data
        unless File.exist?(@private_key)
          raise Tikkie::Api::Exception, "Private key does not exist: #{@private_key}"
        end

        OpenSSL::PKey::RSA.new(File.read(@private_key))
      end

      def jwt_hashing_algorithm
        if @options[:hashing_algorithm]
          unless VALID_HASHING_ALGORITHMS.include?(@options[:hashing_algorithm])
            raise Tikkie::Api::Exception, "Invalid hashing algorithm provided: #{@options[:hashing_algorithm]} (expected: #{VALID_HASHING_ALGORITHMS.join(', ')})"
          end

          @options[:hashing_algorithm]
        else
          DEFAULT_HASHING_ALGORITHM
        end
      end

      def api_url
        if @options[:test]
          SANDBOX_API_URL
        else
          PRODUCTION_API_URL
        end
      end

      def oauth_token_url
        if @options[:test]
          SANDBOX_OAUTH_TOKEN_URL
        else
          PRODUCTION_OAUTH_TOKEN_URL
        end
      end
    end
  end
end
