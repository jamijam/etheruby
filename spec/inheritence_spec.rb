require_relative '../lib/etheruby'

describe "Inheritence mechanism" do

  it "do not mess variables between contracts" do

    klass1 = Class.new do
      include Etheruby::Contract
      contract_method :MyMethodOne
      contract_method :MyMethodTwo
    end

    klass2 = Class.new do
      include Etheruby::Contract
      contract_method :MyMethodThree
      contract_method :MyMethodFour
    end

    klass1_methods = {
      MyMethodOne: {
        name: :MyMethodOne,
        params: [],
        signature: "0xea68fe5f"
      },
      MyMethodTwo: {
        name: :MyMethodTwo,
        params: [],
        signature: "0x684a6a26"
      }
    }

    klass2_methods = {
      MyMethodThree: {
        name: :MyMethodThree,
        params: [],
        signature: "0xa86dc1ea"
      },
      MyMethodFour: {
        name: :MyMethodFour,
        params: [],
        signature: "0x9dde2745"
      }
    }

    expect(klass1.contract_methods).to eq(klass1_methods)
    expect(klass2.contract_methods).to eq(klass2_methods)

  end

end
