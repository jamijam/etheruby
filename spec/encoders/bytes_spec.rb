require_relative '../../lib/etheruby/encoders/bytes'

describe Etheruby::Encoders::Byte do

  it 'encodes correctly' do
    expect(described_class.new(3,[255,254,253]).encode).to eq('fffefd'.ljust(64,'0'))
  end

  it 'decodes correctly' do
    data = '68656c6c6f21'.ljust(64,'0')
    parsed_data = [104, 101, 108, 108, 111, 33]
    expect(described_class.new(6,data).decode).to eq(parsed_data)
  end

end

describe Etheruby::Encoders::Bytes do

  it 'encodes correctly' do
    data = '6'.rjust(64,'0') + '68656c6c6f21'.ljust(64,'0')
    expect(described_class.new([104, 101, 108, 108, 111, 33]).encode).to eq(data)
  end

  it 'decodes correctly' do
    data = '6'.rjust(64,'0') + '68656c6c6f21'.ljust(64,'0')
    parsed_data = [104, 101, 108, 108, 111, 33]
    expect(described_class.new(data).decode).to eq(parsed_data)
  end

end
