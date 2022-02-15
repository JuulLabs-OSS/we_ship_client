# frozen_string_literal: true

require 'we_ship_client/entities/base'
require 'we_ship_client/entities/responses/proof_of_delivery'
require 'we_ship_client/entities/responses/tracking_item'

module WeShipClient
  module Entities
    module Responses
      # The details of a single order returned by `Interactors::GetTracking`.
      class TrackOrder < Base
        attribute :address1, Types::Strict::String
        attribute :address2, Types::Strict::String.optional
        attribute :carrier, Types::Strict::String.optional
        attribute :carrier_tracking_num, Types::Strict::String.optional
        attribute :city, Types::Strict::String
        attribute :client_ref1, Types::Strict::String
        attribute :customer_code, Types::Strict::String
        attribute :estimated_delivery_date, Types::Strict::String.optional
        attribute :fgw_order_id, Types::Coercible::Integer.optional
        attribute :internal_tracking_num, Types::Strict::String.optional
        attribute :last_tracking_update, Types::Strict::String.optional
        attribute :name, Types::Strict::String
        attribute :postal_code, Types::Strict::String
        attribute? :proof_of_delivery, ProofOfDelivery.optional
        attribute :state, Types::Strict::String
        attribute :tracking_items, Types::Strict::Array.of(TrackingItem)
        attribute :upload_date, Types::Strict::String
      end
    end
  end
end
