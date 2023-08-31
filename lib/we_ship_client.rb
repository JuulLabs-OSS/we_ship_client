# frozen_string_literal: true

require 'we_ship_client/client'
require 'we_ship_client/entities'
require 'we_ship_client/exceptions'
require 'we_ship_client/token_client'
require 'we_ship_client/interactors/get_tracking'
require 'we_ship_client/interactors/process_orders'
require 'we_ship_client/transforms/tracking_item'

module WeShipClient
  def self.logger
    @logger ||= defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
  end
end
