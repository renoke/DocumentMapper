require File.dirname(__FILE__) + '/../../../spec_helper'

describe Validatable::ValidatesPresenceOf do
  
  before(:all) do
    class ::Water < KeyValueMapper::Document
      validates_presence_of :temp
    end
  end

  
  it "should validate if field is a present" do
    @it = ::Water.new
    @it.temp = 33
    @it.should be_valid
  end
  
  it "should not validate if field is not present" do
    @it = ::Water.new
    @it.depth = 'thirty-three'
    @it.should_not be_valid
  end
end