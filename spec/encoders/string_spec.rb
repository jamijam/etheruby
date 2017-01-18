require_relative '../../lib/etheruby/encoders/string'

describe Etheruby::Encoders::String do

  it 'encodes correctly' do
    data = '6'.rjust(64,'0') + '68656c6c6f21'.ljust(64,'0')
    expect(described_class.new('hello!').encode).to eq(data)
    data = '20'.rjust(64,'0') + '68656c6c6f20657468657265756d20776f726c6420212052207961206f6b203f'
    expect(described_class.new('hello ethereum world ! R ya ok ?').encode).to eq(data)
  end

  it 'decodes correctly' do
    data = '6'.rjust(64,'0') + '68656c6c6f21'.ljust(64,'0')
    expect(described_class.new(data).decode[0]).to eq('hello!')
  end

end
