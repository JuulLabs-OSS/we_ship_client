# frozen_string_literal: true

require 'we_ship_client/entities/base'
require 'we_ship_client/entities/responses/order_accepted'
require 'we_ship_client/entities/responses/rejected_orders'

module WeShipClient
  module Entities
    module Responses
      # The response returned by `Interactors::ProcessOrders`.
      class ProcessOrders < Base
        attribute? :ordersHeldInGateway, Types::Strict::Array.of(OrderAccepted).optional
        attribute? :rejectedorders, RejectedOrders.optional
      end
    end
  end
end
