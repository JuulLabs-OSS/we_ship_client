# frozen_string_literal: true

require 'we_ship_client/entities/base'
require 'we_ship_client/entities/address'
require 'we_ship_client/entities/order_items'

module WeShipClient
  module Entities
    # A single order with all the details.
    class Order < Base
      attribute :orderNo, Types::Strict::String
      attribute :orderDate, Types::Strict::String
      attribute :shipMethod, Types::Strict::String
      attribute :fulfillmentLocation, Types::Strict::String
      attribute? :billToAddress, Address.optional
      attribute :shipToAddress, Address
      attribute :orderItems, OrderItems
    end
  end
end
