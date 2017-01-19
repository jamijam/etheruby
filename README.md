# Etheruby

[![Gem Version](https://img.shields.io/gem/v/etheruby.svg)][ruby-gems]
[![Build Status](https://travis-ci.org/MechanicalSloth/etheruby.svg?branch=master)][travis]
[![codecov](https://codecov.io/gh/MechanicalSloth/etheruby/branch/master/graph/badge.svg)][coverage]

[ruby-gems]: https://rubygems.org/gems/etheruby
[travis]: https://travis-ci.org/MechanicalSloth/etheruby
[coverage]: https://codecov.io/gh/MechanicalSloth/etheruby

Etheruby is a library including a client for the JSON-RPC API and a Object-Contract Mapper to interact with smart-contracts on the Ethereum blockchain.

## Installation

`gem install etheruby`

or add this into your `Gemfile` :

```
gem 'etheruby'
```

And then run `bundle install`.

## The client

The client is pretty straightforward to use. It uses `method_missing` to map all the possible calls. So, if it exists here : https://github.com/ethereum/wiki/wiki/JSON-RPC it works here.

```
balance = Etheruby::Client.eth.getBalance('0x407d73d8a49eeb85d32cf465507dd71d507100c1','latest')
vers = Etheruby::Client.net.version
sync = Etheruby::Client.eth.syncing
```

## The OCM : Object-Contract Mapper

Etheruby is the first project of its kind. It aims to provide an easy and elegant way to describe a contract, and a native way to interact with it.

I called it an `OCM` for `Object-Contract Mapper`, since, like an `ODM` or an `ORM`, it maps another data type to ruby object to make it easier to manipulate it.

Let's review an example. Given the contract :

```
contract Foo {
  function bar(fixed[2] xy) {}
  function baz(uint32 x, bool y) returns (bool r) { r = x > 32 || y; }
  function sam(bytes name, bool z, uint[] data) {}
  function f(uint,uint32[],bytes10,bytes) {}
}
```

Thus for our `Foo` if we wanted to describe it with Etheruby, we would simply create a `Foo` class and make it inherit from the `Etheruby::Contract` class :

```
class Foo < Etheruby::Contract
  at_address 0x57eb1e64d972d9937c6f6f07a865e91608252c97
  method :bar do
    parameters array(:fixed128x128, 2)
  end
  method :baz do
    parameters :uint32, :bool
    returns :bool
  end
  method :sam do
    parameters :bytes, :bool, array(:uint256)
    returns :bool
  end
  method :f do
    parameters :uint256, array(:uint32), :bytes10, :bytes
  end
end
```

Now, we can use the Contract like if it was a ruby object. All methods on the contract are static methods on the ruby object.

Here is the list of the arguments you can use in the `method` describer :

Keyword | Type | Semantic
------- | ---- | --------
from | String | Set the from address for this method call.
parameters | Array | Set the types of arguments this method can receive.
returns | Array | Set the returns types.
value | FixNum | Set the value of ether sent with this method.
gas | FixNum | Sets the gas to use with this method.
gas_price | FixNum | Set the gas_price to use with this method.

If your method does not take any arguments and do not returns anything, you can remove the block after the keyword.

```
Foo.bar([2.125, 8.5])
Foo.baz(69,true).to eq(false)
Foo.sam("dave".codepoints, true, [1,2,3])
Foo.f(0x123, [0x456, 0x789], "1234567890".codepoints, "Hello, world!".codepoints)
```

Return types of the method are also casted to native ruby types, therefore you have a full interoperability between the contract execution and the ruby program that consumes it.

## Issues

If you find an issue, please open an issue here, on Github.

## How to contribute ?

If you want to help this project, please check the opened issues on Github, fork this repo, fix the issue and do a pull request here. Do not mess with the version of the gem, I'll handle it.

If you don't want to get involved in the developpement of Etheruby buy you want to help, I love beers and pizza, and I love Ethers. Here is my Ethereum address : `0x5124e63dec9acc65203ea8e5f98d4d151c39889f`
