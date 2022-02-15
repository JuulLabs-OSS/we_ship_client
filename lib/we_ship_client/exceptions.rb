# frozen_string_literal: true

module WeShipClient
  module Exceptions
    class BaseError < RuntimeError
    end

    class AuthenticationError < BaseError
    end

    class NotFoundError < BaseError
    end

    class ServerError < BaseError
    end
  end
end
