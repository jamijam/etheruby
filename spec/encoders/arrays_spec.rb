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
    expect(described_class.new('uint8', 3, data).decode).to eq([[1,2,10],96])
    data = f128x128('01','20') + f128x128('01','40') + f128x128('01','80')
    expect(described_class.new('ufixed128x128', 3, data).decode).to eq([[1.125,1.25,1.5], 96])
  end

  it 'encodes dynamic-types correctly' do
    expect(described_class.new('string', 2, ['hello', 'world']).encode).to \
    eq(
      '40'.rjust(64, '0') +
      '80'.rjust(64, '0') +
      '5'.rjust(64, '0') +
      '68656c6c6f'.ljust(64, '0') +
      '5'.rjust(64, '0') +
      '776f726c64'.ljust(64, '0')
    )
  end

  it 'decodes dynamic-types correctly' do
    data = '40'.rjust(64, '0') +
           '80'.rjust(64, '0') +
           '5'.rjust(64, '0') +
           '68656c6c6f'.ljust(64, '0') +
           '5'.rjust(64, '0') +
           '776f726c64'.ljust(64, '0')
    expect(described_class.new('string', 2, data).decode).to eq([['hello', 'world'], 192])
  end

  context 'nested dynamic-types arrays case' do

    let(:data) {
      '40'.rjust(64,'0') +
      '80'.rjust(64,'0') +
      '01'.rjust(64,'0') +
      '68'.ljust(64,'0') +
      '01'.rjust(64,'0') +
      '65'.ljust(64,'0') +
      '40'.rjust(64,'0') +
      '80'.rjust(64,'0') +
      '01'.rjust(64,'0') +
      '6c'.ljust(64,'0') +
      '01'.rjust(64,'0') +
      '6f'.ljust(64,'0')
    }

    let(:raw_data) { [['h','e'],['l','o']] }

    it 'encodes correctly' do
      expect(described_class.new('string[2]', 2, raw_data).encode).to eq(data)
    end

    it 'decodes correctly' do
      expect(described_class.new('string[2]', 2, data).decode).to eq([raw_data, 384])
    end

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
    expect(described_class.new('uint8', '3'.rjust(64,'0') + data).decode).to eq([[1,2,10], 128])
    data = f128x128('01','20') + f128x128('01','40') + f128x128('01','80')
    expect(described_class.new('ufixed128x128', '3'.rjust(64,'0') + data).decode).to eq([[1.125,1.25,1.5], 128])
  end


end
