# frozen_string_literal: true

require 'we_ship_client/client'
require 'we_ship_client/exceptions'

module WeShipClient
  class TokenClient < Client
    # @raise [Exceptions::AuthenticationError] If status is 401
    # @raise [Exceptions::ServerError] If status is not 200
    # @return [String] The access token
    def generate_access_token
      response = http_client.post(
        "#{base_url}/token",
        data: {
          username: ENV['WE_SHIP_USERNAME'],
          password: ENV['WE_SHIP_PASSWORD']
        }
      )

      raise_token_generation_exception(response) unless response.status == 200

      JSON.parse(response.body)['access_token']
    end

    private

    def raise_token_generation_exception(response)
      case response.status
      when 401
        raise WeShipClient::Exceptions::AuthenticationError, response.body
      else
        raise WeShipClient::Exceptions::ServerError, response.body
      end
    end
  end
end
