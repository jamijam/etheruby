require_relative '../../lib/etheruby/encoders/int'

describe Etheruby::Encoders::Int do

  it 'encodes correctly' do
    expect(described_class.new(3).encode).to eq('03'.rjust(64,'0'))
    expect(described_class.new(-3).encode).to eq('fd'.rjust(64,'f'))
    expect(described_class.new(-14).encode).to eq('f2'.rjust(64,'f'))
  end

  it 'decodes correctly' do
    expect(described_class.new('03'.rjust(64,'0')).decode).to eq([3,32])
    expect(described_class.new('fd'.rjust(64,'f')).decode).to eq([-3,32])
    expect(described_class.new('f2'.rjust(64,'f')).decode).to eq([-14,32])
  end

end

describe Etheruby::Encoders::Uint do

  it 'encodes correctly' do
    expect{described_class.new(-3).encode}.to raise_error(Etheruby::Encoders::InvalidFormatForDataError)
    expect(described_class.new(11).encode).to eq('0b'.rjust(64, '0'))
  end

  it 'decodes correctly' do
    expect(described_class.new('0f'.rjust(64, '0')).decode).to eq([15,32])
    expect(described_class.new('10'.rjust(64, '0')).decode).to eq([16,32])
    expect(described_class.new('1010'.rjust(64, '0')).decode).to eq([4112,32])
  end

end
