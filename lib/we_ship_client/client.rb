# frozen_string_literal: true

require 'loogi_http'
require 'loogi_http/connection'

module WeShipClient
  class Client
    DEFAULT_TIMEOUT = 90

    attr_reader :http_client, :logger

    # @param http_client [LoogiHttp::Connection]
    # @param logger [Logger]
    # @param timeout [Integer,nil] The request timeout
    def initialize(http_client: LoogiHttp::Connection, logger: LoogiHttp.logger, timeout: nil)
      timeout ||= DEFAULT_TIMEOUT

      @http_client = http_client.new(
        Faraday::Connection.new do |connection|
          connection.request :json
          connection.adapter Faraday.default_adapter
          connection.options[:open_timeout] = timeout
          connection.options[:timeout] = timeout
        end
      )
      @logger = logger
    end

    def base_url
      ENV['WE_SHIP_BASE_URL']
    end
  end
end
