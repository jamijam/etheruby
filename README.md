# Etheruby
![](https://raw.githubusercontent.com/FranceChain-Solutions/etheruby/master/etheruby.png)

[![Build Status](https://travis-ci.org/FranceChain-Solutions/etheruby.svg?branch=master)][travis]
[![codecov](https://codecov.io/gh/FranceChain-Solutions/etheruby/branch/master/graph/badge.svg)][coverage]

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

### Usage with Ruby on Rails

You can use Etheruby from Ruby on Rails. Just add the gem to your Gemfile and then run the `rake etheruby:setup` task. It will create a new folder under `app/contracts` and create the default `app/config/etheruby.yml` configuration file.

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
  function thisIsCamelCase() {}
}
```

Thus for our `Foo` if we wanted to describe it with Etheruby, we would simply create a `Foo` class and make it inherit from the `Etheruby::Contract` class :

```
class Foo
  include Etheruby::Contract
  at_address 0x57eb1e64d972d9937c6f6f07a865e91608252c97
  contract_method :bar do
    parameters array(:fixed128x128, 2)
  end
  contract_method :baz do
    parameters :uint32, :bool
    returns :bool
  end
  contract_method :sam do
    parameters :bytes, :bool, array(:uint256)
    returns :bool
  end
  contract_method :f do
    parameters :uint256, array(:uint32), :bytes10, :bytes
  end
  contract_method :thisIsCamelCase
end
```

Now, we can use the Contract like if it was a ruby object. All methods on the contract are static methods on the ruby object.

Here is the list of the arguments you can use in the `method` describer :

Keyword | Type | Semantic
------- | ---- | --------
from | String | Set the from address for this method call.
parameters | Array | Set the types of arguments this method can receive.
returns | Array | Set the return types.
value | FixNum | Set the value of ether sent with this method.
gas | FixNum | Sets the gas to use with this method.
gas_price | FixNum | Set the gas_price to use with this method.

If your method doesn't take any argument and doesn't return anything, you can remove the block after the keyword.

```
Foo.bar([2.125, 8.5])
Foo.baz(69,true)
Foo.sam("dave".codepoints, true, [1,2,3])
Foo.f(0x123, [0x456, 0x789], "1234567890".codepoints, "Hello, world!".codepoints)
Foo.this_is_camel_case
Foo.thisIsCamelCase
```

Return types of the method are also casted to native ruby types, therefore you have a full interoperability between the contract execution and the ruby program that consumes it.

The last two calls : `this_is_camel_case / thisIsCamelCase` are bound to the same method. `this_is_camel_case` will be resolved to the `thisIsCamelCase`.

If you return multiple values, like `f(uint a) returns (uint b, string c)` you can create named variables in the contract definition to easily access them :

```
contract_method :f do
  parameters :uint256
  returns b: :uint,
          c: :string
end
response = Contract.f(1)
response.b
response.c
...
```

## Issues

A major issue have been found in V1 API design, due to this, the compatibility is not assured between V1 and V2 : note that inheritance is not working anymore. Now, you must use the `include` method like this :

```
  class Foo
    include Etheruby::Contract
  end
```

Known issue : The way on `Ruby on rails` to load Contracts from `/app/contracts` is not perfect. You must relaunch `rails s` after a contract definition modification. If somebody can help me to achieve this in a cleaner way, I'll be happy ;).

If you find an issue, please open an issue here, on Github.

## How to contribute ?

If you want to help this project, please check the opened issues on Github, fork this repo, fix the issue and do a pull request here. Do not mess with the version of the gem, I'll handle it.

If you don't want to get involved in the developpement of Etheruby but you want to help, I love beers and pizza, and I love Ethers. Here is my Ethereum address : `0x5124e63dec9acc65203ea8e5f98d4d151c39889f`
