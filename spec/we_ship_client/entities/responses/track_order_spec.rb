require 'spec_helper'
require 'we_ship_client/entities/responses/track_order'
require 'we_ship_client/entities/responses/tracking_item'

RSpec.describe WeShipClient::Entities::Responses::TrackOrder do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        address1: '100 Main Street',
        address2: 'Apt 1D',
        carrier: 'UPS',
        carrier_tracking_num: '14440A92A89999999999',
        city: 'Fishers',
        client_ref1: '1043_1',
        customer_code: 'ACME',
        estimated_delivery_date: 'Thu, 16 Jun 2016 19:09:00 GMT',
        fgw_order_id: 123_789,
        internal_tracking_num: '6FDA2EB349494837E',
        last_tracking_update: 'Fri, 22 Jul 2016 18:34:32 GMT',
        name: 'TEST John Smith',
        postal_code: '46038',
        proof_of_delivery: nil,
        state: 'IN',
        tracking_items: [
          WeShipClient::Entities::Responses::TrackingItem.new(
            location: 'PALATINE IL US',
            message: 'DEPARTURE SCAN',
            status_type: 'I',
            tracking_item_date: 'Wed, 15 Jun 2020 20:48:00 GMT',
            tracking_item_id: 2_496_900
          )
        ],
        'upload_date': 'Mon, 13 Jun 2020 16:34:08 GMT'
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when tracking_items is empty' do
      it 'accepts empty tracking_items' do
        required_attributes[:tracking_items] = []
        is_expected.to be_a(described_class)
      end
    end

    context 'when fgw_order_id is nil' do
      it 'accepts nil fgw_order_id' do
        required_attributes[:fgw_order_id] = nil
        is_expected.to be_a(described_class)
      end
    end

    context 'when carrier is nil' do
      it 'accepts it' do
        required_attributes[:carrier] = nil
        is_expected.to be_a(described_class)
      end
    end

    context 'when carrier_tracking_num is nil' do
      it 'accepts it' do
        required_attributes[:carrier_tracking_num] = nil
        is_expected.to be_a(described_class)
      end
    end

    context 'when internal_tracking_num is nil' do
      it 'accepts it' do
        required_attributes[:internal_tracking_num] = nil
        is_expected.to be_a(described_class)
      end
    end

    context 'when last_tracking_update is nil' do
      it 'accepts it' do
        required_attributes[:last_tracking_update] = nil
        is_expected.to be_a(described_class)
      end
    end

    context 'when proof_of_delivery is missing' do
      let(:required_attributes) do
        attrs = super()
        attrs.delete(:proof_of_delivery)
        attrs
      end

      it { is_expected.to be_a(described_class) }
    end

    context 'when integers are provided as coercible strings' do
      let(:required_attributes) do
        super().merge(fgw_order_id: '123789')
      end

      it { is_expected.to be_a(described_class) }
    end
  end
end
