require 'spec_helper'
require 'we_ship_client/entities/track_request'

RSpec.describe WeShipClient::Entities::TrackRequest do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        order_id: ['123789'],
        client_ref1: ['1043_1'],
        carrier_tracking_num: ['14440A92A89999999999'],
        internal_tracking_num: ['6FDA2EB349494837E'],
        customer_code: ['ACME'],
        status: 'I',
        page_num: 0,
        num_records: 100,
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when not setting page_num' do
      it 'uses default page_num value' do
        required_attributes.delete(:page_num)
        is_expected.to be_a(described_class)
      end
    end

    context 'when not setting num_records' do
      it 'uses default num_records value' do
        required_attributes.delete(:num_records)
        is_expected.to be_a(described_class)
      end
    end
  end
end
