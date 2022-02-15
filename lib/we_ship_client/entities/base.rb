# frozen_string_literal: true

require 'dry-struct'
require_relative 'types'

module WeShipClient
  module Entities
    class Base < Dry::Struct
      transform_keys(&:to_sym)

      # This sets dry types to use the default value when nil is passed
      transform_types do |type|
        if type.default?
          type.constructor do |value|
            value.nil? ? Dry::Types::Undefined : value
          end
        else
          type
        end
      end
    end
  end
end
