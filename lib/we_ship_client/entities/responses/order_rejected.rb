# frozen_string_literal: true

require 'we_ship_client/entities/base'

module WeShipClient
  module Entities
    module Responses
      # Details of a single rejected order.
      class OrderRejected < Base
        attribute :description, Types::Strict::String
        attribute? :referenceNo, Types::Strict::String.optional
        attribute :status, Types::Strict::String
        attribute? :type, Types::Strict::String.optional
      end
    end
  end
end
