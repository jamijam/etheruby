require_relative '../../lib/etheruby'

describe 'integration test' do

  it 'works ?' do
    class Citizen < Etheruby::Contract
      # Contract address on the blockchain
      at_address 0x57eb1e64d972d9937c6f6f07a865e91608252c97
      # ABI Definition
      method :greet
      method :multiply do
        parameters :uint256, :uint256
        returns :uint256
      end
    end
    Citizen.greet
    Citizen.multiply(4,5)
  end

end
