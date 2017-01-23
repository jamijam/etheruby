require_relative '../lib/etheruby/ether_multipliable'

describe EtherMultipliable do

  it 'converts kwei to wei' do
    expect(3.kwei).to eq(3000)
  end

  it 'converts mwei to wei' do
    expect(3.mwei).to eq(3000000)
  end

  it 'converts mwei to wei' do
    expect(3.mwei).to eq(3000000)
  end

  it 'converts gwei to wei' do
    expect(3.gwei).to eq(3000000000)
  end

  it 'converts szabo to wei' do
    expect(3.szabo).to eq(3000000000000)
  end

  it 'converts finney to wei' do
    expect(3.finney).to eq(3000000000000000)
  end

  it 'converts ethers to wei' do
    expect(3.ether).to eq(3000000000000000000)
  end

  it 'converts 0.ethers to wei' do
    expect(0.3.ether).to eq(300000000000000000)
  end

  it 'converts kether to wei' do
    expect(3.kether).to eq(3000000000000000000000)
  end

  it 'converts mether to wei' do
    expect(3.mether).to eq(3000000000000000000000000)
  end

  it 'converts gether to wei' do
    expect(3.gether).to eq(3000000000000000000000000000)
  end

  it 'converts tether to wei' do
    expect(3.tether).to eq(3000000000000000000000000000000)
  end

  it 'converts wei to ethers' do
    expect(3000000000000000000.from_wei(:ether)).to eq(3)
  end

  it 'converts wei to kethers' do
    expect(3000000000000000000.from_wei(:kether)).to eq(0.003)
  end

end
