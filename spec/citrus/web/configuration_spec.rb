require 'spec_helper'

describe Citrus::Web::Configuration do

  let(:configuration) { described_class.new(root, streamer_url) }
  let(:root)          { '/world' }
  let(:streamer_url)  { 'http://stream.citrus-ci.dev' }

  specify { expect(configuration).to            respond_to(:event_pubsub_address) }
  specify { expect(configuration).to            respond_to(:build_console_pubsub_address) }
  specify { expect(configuration).to            respond_to(:subscription_pubsub_address) }
  specify { expect(configuration.cache_root).to eq('/world/cache')  }
  specify { expect(configuration.build_root).to eq('/world/builds') }

end
