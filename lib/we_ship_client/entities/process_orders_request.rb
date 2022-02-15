# frozen_string_literal: true

require 'we_ship_client/entities/base'
require 'we_ship_client/entities/order'

module WeShipClient
  module Entities
    # The request payload used by `Interactors::ProcessOrders`.
    class ProcessOrdersRequest < Base
      # NOTE: The order of these attributes MUST remain this way
      # or the API will not properly handle the request and instead
      # throw: {
      #  :response=>{
      #    :invalidrequest=>{
      #       :description=>"Invalid content was found starting with element 'clientCode'. One of '{order}' is expected.",
      #       :status=>"Fail"
      #  }}}
      attribute :formatVersion, Types::Strict::String.default(ENV['WE_SHIP_FORMAT_VERSION'])
      attribute :clientCode, Types::Strict::String.default(ENV['WE_SHIP_CUSTOMER_CODE'])
      attribute :allowDuplicates, Types::Strict::String.default(ENV['WE_SHIP_ALLOW_DUPLICATES'])
      attribute :order, Types::Strict::Array.of(Order)
    end
  end
end
