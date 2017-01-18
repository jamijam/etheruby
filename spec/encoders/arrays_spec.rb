require_relative '../../lib/etheruby/encoders/arrays'

describe Etheruby::Encoders::StaticArray do

  it 'encodes static-types correctly' do
    data = '1'.rjust(64,'0') + '2'.rjust(64,'0') + 'a'.rjust(64,'0')
    expect(described_class.new('uint8', 3, [1,2,10]).encode).to eq(data)
    data = f128x128('01','20') + f128x128('01','40') + f128x128('01','80')
    expect(described_class.new('ufixed128x128', 3, [1.125,1.25,1.5]).encode).to eq(data)
  end

  it 'decodes static-types correctly' do
    data = '1'.rjust(64,'0') + '2'.rjust(64,'0') + 'a'.rjust(64,'0')
    expect(described_class.new('uint8', 3, data).decode).to eq([1,2,10])
    data = f128x128('01','20') + f128x128('01','40') + f128x128('01','80')
    expect(described_class.new('ufixed128x128', 3, data).decode).to eq([1.125,1.25,1.5])
  end

  it 'encodes dynamic-types correctly' do

  end

  it 'decodes dynamic-types correctly' do

  end

end

describe Etheruby::Encoders::DynamicArray do

  it 'passes data to static array encoder correctly' do
    data = '1'.rjust(64,'0') + '2'.rjust(64,'0') + 'a'.rjust(64,'0')
    expect(described_class.new('uint8', [1,2,10]).encode).to eq('3'.rjust(64,'0') + data)
    data = f128x128('01','20') + f128x128('01','40') + f128x128('01','80')
    expect(described_class.new('ufixed128x128', [1.125,1.25,1.5]).encode).to eq('3'.rjust(64,'0') + data)
  end

  it 'passes data to static array decoder correctly' do
    data = '1'.rjust(64,'0') + '2'.rjust(64,'0') + 'a'.rjust(64,'0')
    expect(described_class.new('uint8', '3'.rjust(64,'0') + data).decode).to eq([1,2,10])
    data = f128x128('01','20') + f128x128('01','40') + f128x128('01','80')
    expect(described_class.new('ufixed128x128', '3'.rjust(64,'0') + data).decode).to eq([1.125,1.25,1.5])
  end

end
