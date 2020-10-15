# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'logger'

module Tikkie
  module Api
    # Make authenticated HTTP requests to the Tikkie API.
    class Request
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def get(path, params = {})
        request(:get, path, params)
      end

      def post(path, params = {}, body = {})
        request(:post, path, params, body)
      end

      def delete(path, params = {})
        request(:delete, path, params)
      end

      private

      def request(http_method, path, params = {}, body = {})
        uri = URI.join(config.api_url, path)
        uri.query = URI.encode_www_form(params) unless params.empty?

        if ENV['TIKKIE_DEBUG']
          logger.debug("[Tikkie] Request: #{http_method.upcase} #{uri}")
        end

        case http_method
        when :get
          request = Net::HTTP::Get.new(uri)
        when :post
          request = Net::HTTP::Post.new(uri)
          request.body = body.to_json
        when :delete
          request = Net::HTTP::Delete.new(uri)
        else
          raise Tikkie::Api::Exception, "Invalid HTTP method: #{http_method}"
        end

        request["Accept"] = "application/json"
        request["Content-Type"] = "application/json"
        request["Api-Key"] = config.api_key
        request["X-App-Token"] = config.app_token if config.app_token
        request["User-Agent"] = "Ruby tikkie-api/#{Tikkie::Api::VERSION}"

        client = Net::HTTP.new(uri.hostname, uri.port)
        client.use_ssl = uri.scheme == "https"
        client.verify_mode = OpenSSL::SSL::VERIFY_PEER

        begin
          response = Tikkie::Api::Response.new(client.request(request))
        # Try to catch some common exceptions Net::HTTP might raise.
        rescue Errno::ETIMEDOUT, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::EHOSTUNREACH,
               IOError, SocketError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::OpenTimeout,
               Net::ProtocolError, Net::ReadTimeout, OpenSSL::SSL::SSLError => e
          raise Tikkie::Api::Exception, e.message
        end

        if ENV['TIKKIE_DEBUG']
          logger.debug("[Tikkie] Response: #{response.http_code}, body: #{response.body}")
        end

        raise Tikkie::Api::Exception, "Invalid payload" if response.invalid?
        raise Tikkie::Api::RequestError, response if response.error?

        response
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
