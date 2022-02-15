# frozen_string_literal: true

require 'we_ship_client/entities/base'

module WeShipClient
  module Entities
    # The request payload used by `Interactors::GetTracking`.
    class TrackRequest < Base
      BATCH_SIZE = 500

      attribute? :order_id, Types::Strict::Array.of(Types::Strict::String)
      attribute? :client_ref1, Types::Strict::Array.of(Types::Strict::String)
      attribute? :carrier_tracking_num, Types::Strict::Array.of(Types::Strict::String)
      attribute? :internal_tracking_num, Types::Strict::Array.of(Types::Strict::String)
      attribute :customer_code, Types::Strict::Array.of(Types::Strict::String)
      attribute? :status, Types::Strict::String.enum('M', 'I', 'D', 'R', 'X', 'P', 'N', 'C')
      attribute :page_num, Types::Strict::Integer.default(0)
      attribute :num_records, Types::Strict::Integer.default(BATCH_SIZE)
    end
  end
end
