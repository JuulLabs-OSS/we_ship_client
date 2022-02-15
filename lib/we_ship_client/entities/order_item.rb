# frozen_string_literal: true

require 'we_ship_client/entities/base'

module WeShipClient
  module Entities
    # A single order item.
    class OrderItem < Base
      attribute :productName, Types::Strict::String
      attribute :productSKU, Types::Strict::String
      attribute :productType, Types::Strict::String.default(ENV['WE_SHIP_DEFAULT_PRODUCT_TYPE'])
      attribute :quantity, Types::Strict::Integer
      attribute :weight, Types::Strict::String
    end
  end
end
