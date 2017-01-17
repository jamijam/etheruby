require_relative '../../lib/etheruby/arguments_generator'

describe Etheruby::ArgumentsGenerator do

  context 'string serialization' do

    it 'works on case 1' do
      s = described_class.new([:uint8,:string],[42,'hello!'])
      repr ='2a000000000000000000000000000000000000000000000000000000000000000668656c6c6f21'
      expect(s.to_s).to eq(repr)
    end

    it 'works on case 2' do
      s = described_class.new(['uint8[2]','uint8[]'],[ [21,42] , [22,44] ])
      repr ='152a0000000000000000000000000000000000000000000000000000000000000002162c'
      expect(s.to_s).to eq(repr)
    end

    it 'works on case 3' do
      s = described_class.new([:ufixed8x8,:uint8],[BigDecimal('1.25'), 42])
      repr = '01402a'
      expect(s.to_s).to eq(repr)
    end

  end

  context 'encoders' do
    let(:subject){ described_class.new([],[]) }

    it 'encodes ufixed<M> into hexadecimal base' do
      expect(subject.ufixed_encode(8,8,BigDecimal('1.125'))).to eq('0120')
      expect(subject.ufixed_encode(8,8,BigDecimal('1.25'))).to eq('0140')
      expect(subject.ufixed_encode(8,8,BigDecimal('1.5'))).to eq('0180')
      expect(subject.ufixed_encode(8,8,BigDecimal('1.75'))).to eq('01c0')
      expect(subject.ufixed_encode(8,8,BigDecimal('1.8125'))).to eq('01d0')
      expect(subject.ufixed_encode(8,80,BigDecimal('0.36'))).to eq('005c28f5c28f5c28f5c28f')
      expect(subject.ufixed_encode(8,80,BigDecimal('15.34'))).to eq('0f570a3d70a3d70a3d70a3')
    end

    it 'encodes fixed<M> into hexadecimal base' do
      expect(subject.fixed_encode(8,8,BigDecimal('-1.25'))).to eq('ff40')
    end

    it 'encodes dynamically-sized array' do
      repr = '0000000000000000000000000000000000000000000000000000000000000003050607'
      expect(subject.dynamic_array_encode(:uint8,[5,6,7])).to eq(repr)
    end

    it 'encodes int<M> into hexadecimal base' do
      expect(subject.int_encode(8,-3)).to eq('fd')
      expect(subject.int_encode(8,-14)).to eq('f2')
    end

    it 'encodes uint<M> into hexadecimal base' do
      expect{subject.uint_encode(8,-3)}.to raise_error(Etheruby::InvalidFormatForDataError)
      expect(subject.uint_encode(8,11)).to eq('0b')
    end

    it 'encodes byte<M> into hexadecimal base' do
      expect(subject.byte_encode(3,[255,254,253])).to eq('fffefd')
    end

    it 'encodes strings into hexadecimal base' do
      expect(subject.string_encode('hello!')).to eq('000000000000000000000000000000000000000000000000000000000000000668656c6c6f21')
    end

    it 'encodes bytes into hexadecimal base' do
      expect(subject.bytes_encode([104, 101, 108, 108, 111, 33])).to eq('000000000000000000000000000000000000000000000000000000000000000668656c6c6f21')
    end

    it 'encodes bools into hexadecimal base' do
      expect(subject.bool_encode(false)).to eq('00')
      expect(subject.bool_encode(true)).to eq('01')
    end

    it 'encodes addresses into hexadecimal base' do
      expect(subject.address_encode(0x57eb1e64d972d9937c6f6f07a865e91608252c97)).to eq('57eb1e64d972d9937c6f6f07a865e91608252c97')
    end

  end

end
