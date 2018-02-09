# frozen_string_literal: true

module Tikkie
  module Api
    module Responses
      # Response when requesting users (list).
      class Users < Base
        include Enumerable

        def initialize(response)
          super(response)
        end

        def each(&block)
          users.each(&block)
        end

        private

        def users
          @users ||= begin
            users = []

            data.each do |user|
              users << Tikkie::Api::Responses::User.new(user)
            end

            users
          end
        end
      end
    end
  end
end
