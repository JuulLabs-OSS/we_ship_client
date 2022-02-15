require 'spec_helper'
require 'we_ship_client/entities/order_item'

RSpec.describe WeShipClient::Entities::OrderItem do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        productName: 'US - J1 Devices',
        productSKU: 'J1D1846',
        productType: 'TOBG',
        quantity: 1,
        weight: '0.08'
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when productSKU is missing' do
      it 'raises an exception' do
        required_attributes.delete(:productSKU)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::OrderItem.new] :productSKU is missing in Hash input')
      end
    end

    context 'when quantity is missing' do
      it 'raises an exception' do
        required_attributes.delete(:quantity)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::OrderItem.new] :quantity is missing in Hash input')
      end
    end

    context 'weight' do
      context 'when missing' do
        it 'raises an exception' do
          required_attributes.delete(:weight)

          expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::OrderItem.new] :weight is missing in Hash input')
        end
      end
    end
  end
end
