require 'spec_helper'

describe Citrus::Web::Configuration do

  let(:world)        { described_class.new(root, streamer_url) }
  let(:root)         { '/world' }
  let(:streamer_url) { 'http://stream.citrus-ci.dev' }

  specify { expect(world.cache_root).to eq('/world/cache')  }
  specify { expect(world.build_root).to eq('/world/builds') }

end
