require 'spec_helper'
require 'we_ship_client/entities/address'

RSpec.describe WeShipClient::Entities::Address do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        name: 'John Doe',
        address1: '1 Test Rd',
        address2: nil,
        city: 'Keller',
        state: 'TX',
        postalCode: '76244',
        country: 'US',
        homePhone: '+15553334444'
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when name is missing' do
      it 'raises an exception' do
        required_attributes.delete(:name)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Address.new] :name is missing in Hash input')
      end
    end

    context 'when address1 is missing' do
      it 'raises an exception' do
        required_attributes.delete(:address1)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Address.new] :address1 is missing in Hash input')
      end
    end

    context 'when city is missing' do
      it 'raises an exception' do
        required_attributes.delete(:city)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Address.new] :city is missing in Hash input')
      end
    end

    context 'when state is missing' do
      it 'raises an exception' do
        required_attributes.delete(:state)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Address.new] :state is missing in Hash input')
      end
    end

    context 'when postalCode is missing' do
      it 'raises an exception' do
        required_attributes.delete(:postalCode)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Address.new] :postalCode is missing in Hash input')
      end
    end

    context 'when country is missing' do
      it 'raises an exception' do
        required_attributes.delete(:country)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Address.new] :country is missing in Hash input')
      end
    end

    context 'when homePhone is missing' do
      it 'raises an exception' do
        required_attributes.delete(:homePhone)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Address.new] :homePhone is missing in Hash input')
      end
    end
  end
end
