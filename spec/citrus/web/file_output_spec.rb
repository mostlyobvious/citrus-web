require 'spec_helper'

describe Citrus::Web::FileOutput do

  let(:file_output) { described_class.new(file) }
  let(:file)        { Tempfile.new('file_output') }

  specify { expect(file_output).to respond_to(:write) }
  specify { expect(file_output).to respond_to(:read)  }
  specify { expect(file_output).to respond_to(:path)  }

  it 'should return empty string when output empty' do
    expect(file_output.read).to eq('')
  end

  it 'should accumulate test output' do
    chunks = %w(kaka dudu)
    chunks.each { |c| file_output.write(c) }
    expect(file_output.read).to eq(chunks.join)
  end

  it 'should provide path to allow direct access to ouput file' do
    expect(file_output.path.to_s).to eq(file.path)
  end

end
