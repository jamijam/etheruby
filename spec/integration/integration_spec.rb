require_relative '../../lib/etheruby'

describe 'integration test' do

  class Citizen < Etheruby::Contract
    # Contract address on the blockchain
    at_address 0x57eb1e64d972d9937c6f6f07a865e91608252c97
    # ABI Definition
    method :greet
    method :multiply do
      parameters :uint256, :uint256
      returns :uint256
      gas 21000
    end
    method :other_test do
      parameters array(:uint8, 4), array(:string)
    end
  end

  it 'can wrap calls' do
    expect(Citizen).to receive(:execute_contract_method).with(
      {:name=>:greet, :params=>[], :signature=>"0xcfae3217"}, []
    )
    Citizen.greet
    expect(Citizen).to receive(:execute_contract_method).with(
      {:name=>:multiply, :params=>[:uint256, :uint256], :returns=>[:uint256], :gas=>21000, :signature=>"0x165c4a16"}, [4,5]
    )
    Citizen.multiply(4,5)
  end

end
