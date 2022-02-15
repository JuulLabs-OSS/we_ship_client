# frozen_string_literal: true

require 'we_ship_client/entities/base'
require 'we_ship_client/entities/responses/track_order'

module WeShipClient
  module Entities
    module Responses
      # The response returned by `Interactors::GetTracking`.
      class TrackResponse < Base
        attribute? :page_num, Types::Strict::Integer
        attribute :results, Types::Strict::Array.of(TrackOrder)
      end
    end
  end
end
