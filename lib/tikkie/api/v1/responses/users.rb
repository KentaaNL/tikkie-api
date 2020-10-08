# frozen_string_literal: true

module Tikkie
  module Api
    module V1
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

              unless error?
                data.each do |user|
                  users << Tikkie::Api::V1::Responses::User.new(user)
                end
              end

              users
            end
          end
        end
      end
    end
  end
end
