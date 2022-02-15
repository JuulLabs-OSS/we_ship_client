# frozen_string_literal: true

require 'dry-types'

module WeShipClient
  module Entities
    module Types
      begin
        include Dry.Types()
      rescue NoMethodError # dry-types < 0.15
        include Dry::Types.module
      end
    end
  end
end
