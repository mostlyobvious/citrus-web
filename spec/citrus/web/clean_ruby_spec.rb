require 'spec_helper'

describe 'Ruby syntax' do

  it 'is clean' do
    expect(citrus_web_warnings).to eq([])
  end

  def citrus_web_warnings
    warnings.select { |w| w =~ %r{lib/citrus/web} }
  end

  def warnings
    `ruby -Ilib -w lib/citrus/web.rb 2>&1`.split("\n")
  end

end
