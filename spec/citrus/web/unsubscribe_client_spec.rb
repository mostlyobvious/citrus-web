require 'spec_helper'

describe Citrus::Web::UnsubscribeClient do

  let(:unsubscribe_client)       { described_class.new(subscriptions_repository) }
  let(:subscriptions_repository) { fake(:subscriptions_repository)}
  let(:subscription)             { fake(:subscription) }
  let(:client_id)                { '1337' }

  context '#call' do
    before do
      stub(subscriptions_repository).find_all_by_client_id(client_id) { [subscription] }
      unsubscribe_client.(client_id)
    end

    specify { expect(subscriptions_repository).to have_received.remove_subscription(subscription) }
  end

end
