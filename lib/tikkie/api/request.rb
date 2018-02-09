# frozen_string_literal: true

require 'net/http'
require 'uri'

module Tikkie
  module Api
    # Make authenticated HTTP requests to the Tikkie API.
    class Request
      def initialize(config)
        @config = config
      end

      def get(path, params = {})
        uri = URI.parse(File.join(@config.api_url, path))
        uri.query = URI.encode_www_form(params) unless params.empty?

        request = Net::HTTP::Get.new(uri)
        request["Api-Key"] = @config.api_key
        request["Authorization"] = "Bearer #{access_token}"

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
          http.request(request)
        end

        response
      end

      def post(path, params = {})
        uri = URI.parse(File.join(@config.api_url, path))

        request = Net::HTTP::Post.new(uri)
        request["Api-Key"] = @config.api_key
        request["Authorization"] = "Bearer #{access_token}"
        request["Content-Type"] = "application/json"
        request.body = params.to_json

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
          http.request(request)
        end

        response
      end

      private

      def access_token
        if @access_token.nil? || @access_token.expired?
          @authentication ||= Tikkie::Api::Authentication.new(@config)
          @access_token = @authentication.authenticate
        end

        @access_token.token
      end
    end
  end
end
