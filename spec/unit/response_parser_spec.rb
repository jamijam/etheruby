require_relative '../../lib/etheruby/response_parser'

describe Etheruby::ResponseParser do

  it 'parses uint correctly' do
    expect(described_class.new([:uint8],'0f').parse).to eq(15)
    expect(described_class.new([:uint8],'10').parse).to eq(16)
    expect(described_class.new([:uint16],'1010').parse).to eq(4112)
  end

end
