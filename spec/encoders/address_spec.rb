require_relative '../../lib/etheruby/encoders/address'

describe Etheruby::Encoders::Address do

  it 'encodes correctly' do
    addr = '57eb1e64d972d9937c6f6f07a865e91608252c97'.rjust(64,'0')
    expect(described_class.new(0x57eb1e64d972d9937c6f6f07a865e91608252c97).encode).to eq(addr)
  end

  it 'encodes correctly' do
    addr = '57eb1e64d972d9937c6f6f07a865e91608252c97'.rjust(64,'0')
    expect(described_class.new('0x57eb1e64d972d9937c6f6f07a865e91608252c97').encode).to eq(addr)
  end

  it 'decodes correctly' do
    addr = '57eb1e64d972d9937c6f6f07a865e91608252c97'
    expect(described_class.new(addr.rjust(64,'0')).decode[0]).to eq("0x#{addr}")
  end

end
