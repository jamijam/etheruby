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

    xit 'works on case 3' do
      s = described_class.new([:ufixed8x8,:uint8],[1.25, 42])
      repr = '01042a'
      expect(s.to_s).to eq(repr)
    end

  end

  context 'encoders' do
    let(:subject){ described_class.new([],[]) }

    xit 'encodes ufixed<M> into hexadecimal base' do
      expect(subject.ufixed_encode(8,8,1.25)).to eq('0104')
    end

    xit 'encodes fixed<M> into hexadecimal base' do
      expect(subject.fixed_encode(8,8,-1.25)).to eq('ff04')
    end

    it 'encodes dynamically-sized array' do
      repr = '0000000000000000000000000000000000000000000000000000000000000003050607'
      expect(subject.dynamic_array(:uint8,[5,6,7])).to eq(repr)
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

  context 'matchers' do
    let(:subject){ described_class.new([],[]) }

    it 'matches sized types' do
      match = subject.is_sized_type(:uint256)
      expect(match[1]).to eq('uint')
      expect(match[2]).to eq('256')
    end

    it 'matches statically-sized array' do
      match = subject.is_static_array_type('uint256[4]')
      expect(match[1]).to eq('uint256')
      expect(match[2]).to eq('4')
    end

    it 'matches dynamicaly-sized array' do
      match = subject.is_dynamic_array_type('uint256[]')
      expect(match[1]).to eq('uint256')
    end

    it 'matches statically-sized array of n dimension' do
      match = subject.is_static_array_type('uint256[4][3]')
      expect(match[1]).to eq('uint256[4]')
      expect(match[2]).to eq('3')
    end

    it 'matches dynamicaly-sized array of n dimension' do
      match = subject.is_dynamic_array_type('uint256[][]')
      expect(match[1]).to eq('uint256[]')
    end

    it 'mathes dual-sized types' do
      match = subject.is_dualsized_type('ufloat8x16')
      expect(match[1]).to eq('ufloat')
      expect(match[2]).to eq('8')
      expect(match[3]).to eq('16')
    end

  end

end
