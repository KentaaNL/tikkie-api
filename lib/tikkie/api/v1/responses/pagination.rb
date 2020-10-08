# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      module Responses
        # Helper for paginated responses.
        module Pagination
          attr_accessor :offset, :limit, :elements, :total_elements

          def more_elements?
            @total_elements && @total_elements > @offset + @elements
          end

          def next_offset
            @offset + @limit if more_elements?
          end
        end
      end
    end
  end
end
