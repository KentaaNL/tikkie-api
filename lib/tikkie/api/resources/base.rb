# frozen_string_literal: true

module Tikkie
  module Api
    module Resources
      # Base class for all resources.
      class Base
        attr_reader :config, :options

        def initialize(config, options = {})
          @config = config
          @options = options
          @body = options.delete(:body) if options.key?(:body)
        end

        def load
          @response ||= load_resource

          self
        end

        def save(attributes = {})
          @response = create_resource(attributes)

          self
        end

        def delete
          delete_resource

          nil
        end

        def loaded?
          !@response.nil?
        end

        private

        def load_resource
          raise NotImplementedError
        end

        def create_resource
          raise NotImplementedError
        end

        def delete_resource
          raise NotImplementedError
        end

        def body
          @body ||= begin
            load unless loaded?

            @response.body
          end
        end

        def request
          @request ||= Tikkie::Api::Request.new(config)
        end
      end
    end
  end
end
