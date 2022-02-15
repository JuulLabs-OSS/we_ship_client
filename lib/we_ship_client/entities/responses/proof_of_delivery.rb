# frozen_string_literal: true

require 'we_ship_client/entities/base'

module WeShipClient
  module Entities
    module Responses
      # The proof of delivery data of a single order.
      class ProofOfDelivery < Base
        attribute :additional_information, Types::Strict::String.optional.default(nil)
        attribute :delivery_date, Types::Strict::String.optional.default(nil)
        attribute :signature, Types::Strict::String.optional.default(nil)
        attribute :signer_name, Types::Strict::String.optional.default(nil)
        attribute :visual, Types::Strict::String.optional.default(nil)
      end
    end
  end
end
