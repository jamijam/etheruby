require_relative '../../lib/etheruby/encoders/bool'

describe Etheruby::Encoders::Bool do

  it 'encodes correctly' do
    expect(described_class.new(false).encode).to eq('0'.rjust(64, '0'))
    expect(described_class.new(true).encode).to eq('1'.rjust(64, '0'))
  end

  it 'decodes correctly' do
    expect(described_class.new('1'.rjust(64,'0')).decode).to eq([true, 32])
    expect(described_class.new('0'.rjust(64,'0')).decode).to eq([false, 32])
  end

end
