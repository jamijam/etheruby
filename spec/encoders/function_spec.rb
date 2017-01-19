require_relative '../../lib/etheruby/encoders/function'

describe Etheruby::Encoders::Function do

  it 'encodes correctly' do
    data = {
      address: 0x57eb1e64d972d9937c6f6f07a865e91608252c97,
      selector: 0x5423ea21
    }
    expect(described_class.new(data).encode).to eq('57eb1e64d972d9937c6f6f07a865e91608252c975423ea210000000000000000')
  end

  it 'decodes correctly' do
    data = '57eb1e64d972d9937c6f6f07a865e91608252c975423ea210000000000000000'
    result = {
      address: '0x57eb1e64d972d9937c6f6f07a865e91608252c97',
      selector: '0x5423ea21'
    }
    expect(described_class.new(data).decode).to eq([result, 32])
  end

end
