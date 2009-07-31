require File.dirname(__FILE__) + '/../../../spec_helper'

describe Validatable::ValidatesAcceptanceOf do
  
  before(:all) do
    class ::Lac < KeyValueMapper::Document
      validates_acceptance_of :water
    end
  end
  
  it "should have a class validations" do
    ::Lac.validations.first.should be_a(Validatable::ValidatesAcceptanceOf)
    ::Lac.validations.first.attribute.should == :water
  end
  
  it "should validate if attribute is true" do
    @it = ::Lac.new
    @it.water = true
    @it.should be_valid
    @it.water = 'true'
    @it.should be_valid
    @it.water = false
    @it.should_not be_valid
  end
  
  it "should validate if attribute is 1" do
    @it = ::Lac.new
    @it.water = 1
    @it.should be_valid
    @it.water = '1'
    @it.should be_valid
    @it.water = 0
    @it.should_not be_valid
  end
  
  it "should not validate if attribute is not true " do
    @it = ::Lac.new
    @it.water = 'false'
    @it.should_not be_valid
  end
  
  it "should add the default message when invalid" do
    @it = ::Lac.new
    @it.valid?.should be_false
    @it.errors.on(:water).should == "must be accepted"
  end
  
  it "should validate with accept option" do
    class ::Sea < KeyValueMapper::Document
      validates_acceptance_of :water, :accept=>'salty'
    end
    it = ::Sea.new(:water=>'salty')
    it.should be_valid
    it.water = 'clear'
    it.should_not be_valid
  end
end
