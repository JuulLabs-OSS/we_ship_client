require 'spec_helper'
require 'we_ship_client/entities/responses/rejected_orders'

RSpec.describe WeShipClient::Entities::Responses::RejectedOrders do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        order: []
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when order is missing' do
      it 'raises an exception' do
        required_attributes.delete(:order)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Responses::RejectedOrders.new] :order is missing in Hash input')
      end
    end
  end
end
