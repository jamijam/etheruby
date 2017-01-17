require_relative '../../lib/etheruby/response_parser'

describe Etheruby::ResponseParser do

  it 'chains returns in response' do
    a = [-7,-128,3]
    expect(described_class.new([:int8,:int8,:int8],'f98003').parse).to eq(a)
  end

  it 'parses int correctly' do
    expect(described_class.new([:int8],'f9').parse).to eq(-7)
    expect(described_class.new([:int8],'80').parse).to eq(-128)
    expect(described_class.new([:int8],'03').parse).to eq(3)
  end

  it 'parses uint correctly' do
    expect(described_class.new([:uint8],'0f').parse).to eq(15)
    expect(described_class.new([:uint8],'10').parse).to eq(16)
    expect(described_class.new([:uint16],'1010').parse).to eq(4112)
  end

  it 'parses string correctly' do
    data = '000000000000000000000000000000000000000000000000000000000000000668656c6c6f21'
    expect(described_class.new([:string],data).parse).to eq('hello!')
  end

  it 'parses bytes array correctly' do
    data = '000000000000000000000000000000000000000000000000000000000000000668656c6c6f21'
    parsed_data = [104, 101, 108, 108, 111, 33]
    expect(described_class.new([:bytes],data).parse).to eq(parsed_data)
  end

  it 'parses boolean correctly' do
    expect(described_class.new([:bool],'01').parse).to eq(true)
    expect(described_class.new([:bool],'00').parse).to eq(false)
  end

  it 'parses addresses correctly' do
    data = '57eb1e64d972d9937c6f6f07a865e91608252c97'
    expect(described_class.new([:address],data).parse).to eq("0x#{data}")
  end

  it 'parses static array correctly' do
    data = '57eb1e64'
    expect(described_class.new(['uint8[4]'],data).parse).to eq([87, 235, 30, 100])
  end

  it 'parses dynamic array correctly' do
    data = '000000000000000000000000000000000000000000000000000000000000000457eb1e64'
    expect(described_class.new(['uint8[]'],data).parse).to eq([87, 235, 30, 100])
  end

end
