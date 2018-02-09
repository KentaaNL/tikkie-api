# frozen_string_literal: true

module Tikkie
  module Api
    module Responses
      # Bank account of a user.
      class BankAccount < Base
        def bank_account_token
          data[:bankAccountToken]
        end

        def bank_account_label
          data[:bankAccountLabel]
        end

        def iban
          data[:iban]
        end
      end
    end
  end
end
