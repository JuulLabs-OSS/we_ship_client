# frozen_string_literal: true

require 'we_ship_client/entities/base'
require 'we_ship_client/entities/order_item'

module WeShipClient
  module Entities
    # Just a container for the order items list.
    # Note the singular "orderItem" name that may be confusing.
    class OrderItems < Base
      attribute :orderItem, Types::Strict::Array.of(OrderItem).constrained(min_size: 1)
    end
  end
end
