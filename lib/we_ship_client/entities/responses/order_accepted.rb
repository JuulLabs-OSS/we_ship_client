# frozen_string_literal: true

require 'we_ship_client/entities/base'

module WeShipClient
  module Entities
    module Responses
      # Details of a single accepted order.
      class OrderAccepted < Base
        attribute :description, Types::Strict::String
        attribute :orderId, Types::Strict::String
        attribute :referenceNo, Types::Strict::String
        attribute :status, Types::Strict::String
        attribute :type, Types::Strict::String
      end
    end
  end
end
