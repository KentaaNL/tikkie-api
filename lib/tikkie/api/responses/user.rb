# frozen_string_literal: true

module Tikkie
  module Api
    module Responses
      # Response when requesting an user.
      class User < Base
        def user_token
          data[:userToken]
        end

        def name
          data[:name]
        end

        # see UserStatus
        def status
          data[:status]
        end

        def active?
          status == Tikkie::Api::Types::UserStatus::ACTIVE
        end

        def bank_accounts
          @bank_accounts ||= begin
            bank_accounts = []

            if data[:bankAccounts]
              data[:bankAccounts].each do |data|
                bank_accounts << Tikkie::Api::Responses::BankAccount.new(data)
              end
            end

            bank_accounts
          end
        end
      end
    end
  end
end
