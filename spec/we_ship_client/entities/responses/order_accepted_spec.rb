require 'spec_helper'
require 'we_ship_client/entities/responses/order_accepted'

RSpec.describe WeShipClient::Entities::Responses::OrderAccepted do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        description: 'Order TESTR00000001 accepted',
        orderId: '12343459',
        referenceNo: 'TESTR00000001',
        status: 'New',
        type: 'Sales Order'
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when description is missing' do
      it 'raises an exception' do
        required_attributes.delete(:description)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Responses::OrderAccepted.new] :description is missing in Hash input')
      end
    end

    context 'when orderId is missing' do
      it 'raises an exception' do
        required_attributes.delete(:orderId)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Responses::OrderAccepted.new] :orderId is missing in Hash input')
      end
    end

    context 'when referenceNo is missing' do
      it 'raises an exception' do
        required_attributes.delete(:referenceNo)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Responses::OrderAccepted.new] :referenceNo is missing in Hash input')
      end
    end

    context 'when status is missing' do
      it 'raises an exception' do
        required_attributes.delete(:status)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Responses::OrderAccepted.new] :status is missing in Hash input')
      end
    end

    context 'when type is missing' do
      it 'raises an exception' do
        required_attributes.delete(:type)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Responses::OrderAccepted.new] :type is missing in Hash input')
      end
    end
  end
end
