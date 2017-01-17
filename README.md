# Etheruby

Etheruby is a library including a client for the JSON-RPC API and a Object-Contract Mapper to interact with smart-contracts.

**This is a work in progress !**

My final goal is to have the possibility to describe a smart-contract this way :

```
class Citizen < Etheruby::Contract
  # Contract address on the blockchain
  at_address 0x57eb1e64d972d9937c6f6f07a865e91608252c97
  # ABI Definition
  method :greet
  method :multiple do
    parameters :int256, :int256
    returns :int256
    value 1
    gas 100
    gas_price 10000
  end
end

# Calling greet method on citizine
puts "Citizen.greet"
Citizen.greet
puts "----------------"
# Calling multiple method
puts "Citizen.multiple(4,5)"
resp = Citizen.multiple(4,5)
```

### What remains to do ?

 - A big part of what remains to implement is the argument encoding/decoding : https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI
 - Tests, using RSpec
 - Maybe review how Etheruby::Contract works for inheritence (it is a bit dirty right now)

### Contribute !

I you want to contribute, you're welcome ! Do a pull request, etc...
