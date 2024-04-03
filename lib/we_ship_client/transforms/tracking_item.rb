# frozen_string_literal: true

require 'active_support'
require 'active_support/time_with_zone'

module WeShipClient
  module Transforms
    # A class that modifies/converts/removes some tracking items data to match our needs.
    # If you want to use your custom logic, create another class and set it on
    # `Interactors::GetTracking#tracking_item_transform_class`
    class TrackingItem
      # Following array of messages mean the status is a delivery exception regardless
      # of what the actual status_type is received from weship
      OVERRIDE_DELIVERED = [
        'Delivered, Signed by 85',
        'Delivered, Signed by no answer at door',
        'Delivered, Signed by LOST'
      ].freeze
      OVERRIDE_DELIVERY_EXCEPTION = ['48'].freeze
      OVERRIDE_STATUS_TO_DELIVERY_EXCEPTION = ['No One Avail Sig Required'].freeze
      OVERRIDE_STATUS_TO_RETURNED = [
        'Delivered, Signed by RETURN',
        'Delivered, Signed by 3 att',
        'Delivered, Signed by RTS'
      ].freeze
      OVERRIDE_STATUS_TO_MANIFEST = ['Electronically Transmitted'].freeze
      DUPLICATE_DELIMITER = '----'
      DELIVERY_ATTEMPTED_MESSAGE = 'Delivery attempt was made'
      RETURNED_MESSAGE = 'Return to Sender'
      UNDELIVERABLE_MESSAGE = 'undeliverable'
      OUT_FOR_DELIVERY_MESSAGE = 'Out for Delivery'

      ET_STATES = %w[CT DE FL GA IN ME MD MA MI NH NJ NY NC OH PA RI SC VT VA WV].freeze
      CT_STATES = %w[AL AR IL IA KS KY LA MN MS MO NE ND OK SD TN TX WI].freeze
      MT_STATES = %w[AZ CO ID MT NM UT WY].freeze
      PT_STATES = %w[CA NV OR WA].freeze

      def call(tracking_item:, state:) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        if should_override_delivered_to_exception?(tracking_item)
          tracking_item.status_type.replace('X')
          tracking_item.message.replace(DELIVERY_ATTEMPTED_MESSAGE)
        elsif should_override_delivered_to_returned?(tracking_item)
          tracking_item.status_type.replace('R')
          tracking_item.message.replace(RETURNED_MESSAGE)
        elsif should_override_delivery_exception_message?(tracking_item)
          tracking_item.message.replace(DELIVERY_ATTEMPTED_MESSAGE)
        elsif should_override_status_to_exception?(tracking_item)
          tracking_item.status_type.replace('X')
        elsif should_override_out_for_delivery_status?(tracking_item)
          tracking_item.status_type.replace('I')
        elsif should_override_exception_to_manifest?(tracking_item)
          tracking_item.status_type.replace('M')
        end

        # if there is a extraneous driver related message text, override to simpler message
        tracking_item.message.replace('With driver') if should_override_driver_details?(tracking_item)
        if should_remove_delimeters?(tracking_item)
          # remove duplicates from message
          tracking_item.message.replace(tracking_item.message.split(DUPLICATE_DELIMITER)[0])
        end
        # weship datetime is local carrier time, so convert it to UTC
        convert_date_to_utc(tracking_item, state)
      end

      def should_override_exception_to_manifest?(tracking_item)
        tracking_item.status_type == 'X' &&
          OVERRIDE_STATUS_TO_MANIFEST.any? do |message|
            tracking_item.message.downcase.start_with?(message.downcase)
          end
      end

      def should_override_delivered_to_exception?(tracking_item)
        tracking_item.status_type == 'D' &&
          [
            OVERRIDE_DELIVERED.any? { |message| tracking_item.message.downcase.start_with?(message.downcase) },
            tracking_item.message.downcase.include?(UNDELIVERABLE_MESSAGE.downcase)
          ].any?
      end

      def should_override_delivered_to_returned?(tracking_item)
        tracking_item.status_type == 'D' &&
          OVERRIDE_STATUS_TO_RETURNED.any? do |message|
            tracking_item.message.downcase.start_with?(message.downcase)
          end
      end

      def should_override_delivery_exception_message?(tracking_item)
        tracking_item.status_type == 'X' &&
          OVERRIDE_DELIVERY_EXCEPTION.any? do |message|
            tracking_item.message.downcase.start_with?(message.downcase)
          end
      end

      def should_override_status_to_exception?(tracking_item)
        OVERRIDE_STATUS_TO_DELIVERY_EXCEPTION.any? do |message|
          tracking_item.message.downcase.start_with?(message.downcase)
        end
      end

      def should_remove_delimeters?(tracking_item)
        tracking_item.message.index(DUPLICATE_DELIMITER)&.positive?
      end

      def should_override_out_for_delivery_status?(tracking_item)
        tracking_item.status_type == 'X' &&
          tracking_item.message.downcase.include?(OUT_FOR_DELIVERY_MESSAGE.downcase)
      end

      def should_override_driver_details?(tracking_item)
        tracking_item.message.downcase.index('driver:')
      end

      def convert_date_to_utc(tracking_item, state)
        date = tracking_item.tracking_item_date
        if date.present?
          timezone = ActiveSupport::TimeZone.new(us_timezone_from(state))
          utc_date = timezone.local_to_utc(DateTime.parse(date)).to_s
          tracking_item.tracking_item_date.replace(utc_date)
        end
      end

      def us_timezone_from(state)
        if ET_STATES.include?(state)
          'Eastern Time (US & Canada)'
        elsif CT_STATES.include?(state)
          'Central Time (US & Canada)'
        elsif MT_STATES.include?(state)
          'Mountain Time (US & Canada)'
        elsif PT_STATES.include?(state)
          'Pacific Time (US & Canada)'
        else # default to est
          'Eastern Time (US & Canada)'
        end
      end
    end
  end
end
