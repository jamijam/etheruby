describe 'integration test' do

  it 'works ?' do
    class Citizen < Etheruby::Contract
      # Contract address on the blockchain
      at_address 0x57eb1e64d972d9937c6f6f07a865e91608252c97
      # ABI Definition
      method :greet do
        parameters :string
      end
    end
    Citizen.greet("hello !")
  end

end
