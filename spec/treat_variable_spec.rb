require_relative '../lib/etheruby/treat_variable'

describe 'TreatVariables' do

  it 'is dispatching to the good methods' do
    expect(Etheruby::treat_variable(:uint256,3,:encode)).to eq('3'.rjust(64,'0'))
    expect(Etheruby::treat_variable(:bytes3,[1,2,3],:encode)).to eq('010203'.ljust(64,'0'))
  end

end
