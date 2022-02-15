require 'spec_helper'
require 'we_ship_client/entities/responses/process_orders'

RSpec.describe WeShipClient::Entities::Responses::ProcessOrders do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {}
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end
  end
end
