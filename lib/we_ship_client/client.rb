# frozen_string_literal: true

require 'loogi_http'
require 'loogi_http/connection'

module WeShipClient
  class Client
    attr_reader :http_client, :logger

    # @param http_client [LoogiHttp::Connection]
    # @param logger [Logger]
    def initialize(http_client: LoogiHttp::Connection, logger: LoogiHttp.logger)
      @http_client = http_client.new(
        Faraday::Connection.new do |connection|
          connection.request :json
          connection.adapter Faraday.default_adapter
          connection.options[:open_timeout] = 90
          connection.options[:timeout] = 90
        end
      )
      @logger = logger
    end

    def base_url
      ENV['WE_SHIP_BASE_URL']
    end
  end
end
