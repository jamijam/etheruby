require_relative '../../lib/etheruby/type_matchers'

describe Etheruby::TypeMatchers do
  
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
