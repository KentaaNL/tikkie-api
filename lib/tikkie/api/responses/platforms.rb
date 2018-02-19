# frozen_string_literal: true

module Tikkie
  module Api
    module Responses
      # Response when requesting platforms (list).
      class Platforms < Base
        include Enumerable

        def each(&block)
          platforms.each(&block)
        end

        private

        def platforms
          @platforms ||= begin
            platforms = []

            unless error?
              data.each do |platform|
                platforms << Tikkie::Api::Responses::Platform.new(platform)
              end
            end

            platforms
          end
        end
      end
    end
  end
end
