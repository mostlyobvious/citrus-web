require 'spec_helper'

describe Citrus::Web::Subscription do

  let(:subscription) { described_class.new(client_id, subject) }
  let(:client_id)    { '31337' }
  let(:subject)      { 'dummy' }

  specify { expect(subscription).to respond_to(:client_id) }
  specify { expect(subscription).to respond_to(:subject) }

end
