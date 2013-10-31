require 'spec_helper'

describe Citrus::Web::Configuration do

  let(:configuration) { described_class.new(root) }
  let(:root)          { '/world' }

  specify { expect(configuration).to respond_to(:event_pubsub_address) }
  specify { expect(configuration).to respond_to(:build_console_pubsub_address) }
  specify { expect(configuration.cache_root).to eq('/world/cache')  }
  specify { expect(configuration.build_root).to eq('/world/builds') }

end
