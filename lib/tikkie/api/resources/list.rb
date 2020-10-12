# frozen_string_literal: true

require 'bigdecimal'

module Tikkie
  module Api
    module Resources
      # Base class for all list resources.
      class List < Base
        attr_reader :page_number, :page_size

        def initialize(config, options = {})
          @page_number = options.fetch(:page_number, 0)
          @page_size = options.fetch(:page_size, 50)
          super(config, options)
        end

        def total_elements
          body[:totalElementCount].to_i
        end

        def total_pages
          (total_elements / BigDecimal(page_size)).ceil
        end

        def next_page
          page_number + 1 if next_page?
        end

        def next_page?
          page_number && (page_number + 1) < total_pages
        end

        def previous_page
          page_number - 1 if previous_page?
        end

        def previous_page?
          page_number && page_number.positive?
        end

        def next
          self.class.new(config, options.merge(page_number: next_page)) if next_page?
        end

        def previous
          self.class.new(config, options.merge(page_number: previous_page)) if previous_page?
        end
      end
    end
  end
end
