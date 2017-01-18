require 'bigdecimal'

require_relative '../../lib/etheruby/encoders/fixed'

describe Etheruby::Encoders::Fixed do

  it 'encodes correctly' do
    expect(described_class.new(128,128,-1.25).encode).to eq(uf128x128('ff','40'))
    expect(described_class.new(128,128,1.125).encode).to eq(f128x128('01','20'))
  end

  it 'decodes correctly' do
    expect(described_class.new(128,128,uf128x128('ff','40')).decode[0]).to eq(-1.25)
    expect(described_class.new(128,128,f128x128('01','20')).decode[0]).to eq(BigDecimal('1.125'))
  end

end

describe Etheruby::Encoders::Ufixed do

  it 'encodes correctly' do
    expect(described_class.new(128,128,1.125).encode).to eq(f128x128('01','20'))
    expect(described_class.new(128,128,1.25).encode).to eq(f128x128('01','40'))
    expect(described_class.new(128,128,1.5).encode).to eq(f128x128('01','80'))
    expect(described_class.new(128,128,1.75).encode).to eq(f128x128('01','c0'))
    expect(described_class.new(128,128,1.8125).encode).to eq(f128x128('01','d0'))
    expect(described_class.new(8,248,BigDecimal('0.36')).encode).to eq('00' + ('5c28f'*14)[0..61])
    expect(described_class.new(8,248,BigDecimal('15.34')).encode).to eq('0f5' + ('70a3d'*14)[0..60])
  end

  it 'decodes correctly' do
    expect(described_class.new(8,248,'00' + ('5c28f'*14)[0..61]).decode[0]).to eq(BigDecimal('0.36'))
    expect(described_class.new(8,248,'0f5' + ('70a3d'*14)[0..60]).decode[0]).to eq(BigDecimal('15.34'))
    expect(described_class.new(128,128,f128x128('01','20')).decode[0]).to eq(BigDecimal('1.125'))
  end

end
