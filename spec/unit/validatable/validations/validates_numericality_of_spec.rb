require File.dirname(__FILE__) + '/../../../spec_helper'

describe Validatable::ValidatesNumericalityOf do
  
  before(:all) do
    class ::Water < KeyValueMapper::Document
      validates_numericality_of :temp
    end
    @it = ::Water.new
  end

  
  it "should validate if field is a number" do
    @it.temp = 33
    @it.should be_valid
  end
  
  it "should not validate if field is not number" do
    @it.temp = 'thirty-three'
    @it.should_not be_valid
  end
end