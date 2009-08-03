require File.dirname(__FILE__) + '/../../../spec_helper'

describe Validatable::ValidatesPresenceOf do
  
  before(:all) do
    class Life < KeyValueMapper::Document
      validates_presence_of :god
    end
  end

  
  it "should validate if field is a present" do
    @it = Life.new
    @it.god = 'Consommation'
    @it.should be_valid
  end
  
  it "should not validate if field is not present" do
    @it = Life.new
    @it.god = nil
    @it.should_not be_valid
  end
end