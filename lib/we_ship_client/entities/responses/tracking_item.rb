# frozen_string_literal: true

require 'we_ship_client/entities/base'

module WeShipClient
  module Entities
    module Responses
      # A single tracking item returned by `Interactors::GetTracking`.
      class TrackingItem < Base
        attribute :location, Types::Strict::String.optional
        attribute :message, Types::Strict::String
        attribute :status_type, Types::Strict::String
        attribute :tracking_item_date, Types::Strict::String.optional.default(nil)
        attribute :tracking_item_id, Types::Coercible::Integer.optional.default(nil)
      end
    end
  end
end
