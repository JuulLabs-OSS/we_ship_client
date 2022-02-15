# frozen_string_literal: true

require 'we_ship_client/entities/base'

module WeShipClient
  module Entities
    # A shipping/billing address.
    class Address < Base
      attribute :name, Types::Strict::String
      attribute :address1, Types::Strict::String
      attribute? :address2, Types::Strict::String.optional
      attribute :city, Types::Strict::String
      attribute :state, Types::Strict::String
      attribute :postalCode, Types::Strict::String
      attribute :country, Types::Strict::String
      attribute :homePhone, Types::Strict::String
    end
  end
end
