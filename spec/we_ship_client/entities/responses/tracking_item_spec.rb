require 'spec_helper'
require 'we_ship_client/entities/responses/tracking_item'

RSpec.describe WeShipClient::Entities::Responses::TrackingItem do
  describe '.attributes' do
    let(:required_attributes) do
      {
        location: 'PALATINE IL US',
        message: 'DEPARTURE SCAN',
        status_type: 'I',
        tracking_item_date: 'Wed, 15 Jun 2020 20:48:00 GMT',
        tracking_item_id: 2_496_900
      }
    end

    subject { described_class.new(required_attributes) }

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when location is nil' do
      let(:required_attributes) do
        {
          location: nil,
          message: 'DEPARTURE SCAN',
          status_type: 'I',
          tracking_item_date: 'Wed, 15 Jun 2020 20:48:00 GMT',
          tracking_item_id: 2_496_900
        }
      end

      it { is_expected.to be_a(described_class) }
    end

    context 'when tracking_item_date is nil' do
      let(:required_attributes) do
        {
          location: 'PALATINE IL US',
          message: 'DEPARTURE SCAN',
          status_type: 'I',
          tracking_item_date: nil,
          tracking_item_id: 2_496_900
        }
      end

      it { is_expected.to be_a(described_class) }
    end

    context 'when tracking_item_date is missing' do
      let(:required_attributes) do
        {
          location: 'PALATINE IL US',
          message: 'DEPARTURE SCAN',
          status_type: 'I',
          tracking_item_id: 2_496_900
        }
      end

      it { is_expected.to be_a(described_class) }
    end

    context 'when tracking_item_id is nil' do
      let(:required_attributes) do
        {
          location: 'PALATINE IL US',
          message: 'DEPARTURE SCAN',
          status_type: 'I',
          tracking_item_date: 'Wed, 15 Jun 2020 20:48:00 GMT',
          tracking_item_id: nil
        }
      end

      it { is_expected.to be_a(described_class) }
    end

    context 'when tracking_item_id is missing' do
      let(:required_attributes) do
        {
          location: 'PALATINE IL US',
          message: 'DEPARTURE SCAN',
          status_type: 'I',
          tracking_item_date: 'Wed, 15 Jun 2020 20:48:00 GMT',
        }
      end

      it { is_expected.to be_a(described_class) }
    end

    context 'when integers are provided as coercible strings' do
      let(:required_attributes) do
        super().merge(tracking_item_id: '2496900')
      end

      it { is_expected.to be_a(described_class) }
    end
  end
end
