require 'spec_helper'

describe Citrus::Web::Configuration do

  let(:world) { described_class.new(root) }
  let(:root)  { '/world' }

  specify { expect(world.cache_root).to eq('/world/cache')  }
  specify { expect(world.build_root).to eq('/world/builds') }

end
