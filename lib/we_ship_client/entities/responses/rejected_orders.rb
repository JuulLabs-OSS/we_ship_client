# frozen_string_literal: true

require 'we_ship_client/entities/base'
require 'we_ship_client/entities/responses/order_rejected'

module WeShipClient
  module Entities
    module Responses
      # Just a container for the rejected orders list.
      # Note the singular "order" name that may be confusing.
      class RejectedOrders < Base
        attribute? :count, Types::Strict::Integer.optional
        attribute :order, Types::Strict::Array.of(OrderRejected).optional
      end
    end
  end
end
