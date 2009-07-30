require File.dirname(__FILE__) + '/../../../spec_helper'

describe Validatable::ValidatesAcceptanceOf do
  
  before(:all) do
    class Cloud < FlatDoc::Mash
      validates_confirmation_of :water
    end
    
    class River < FlatDoc::Mash
      validates_confirmation_of :water, :case_sensitive => false
    end
    
  end
  
  it "should validate the confirmation of a field " do
    @it = Cloud.new
    @it.water = 'clear'
    @it.water_confirmation = 'clear'
    @it.should be_valid
  end
  
  it "should not validate if confirmation differ" do
    @it = Cloud.new
    @it.water = 'clear'
    @it.water_confirmation = 'salty'
    @it.should_not be_valid
  end
  
  it "should not validate if case sensitive is relevent (default)" do
    @it = Cloud.new
    @it.water = 'blue'
    @it.water_confirmation = 'Blue'
    @it.should_not be_valid
  end
  
  it "should have validations model for the class" do
    River.validations.first.should be_a(Validatable::ValidatesConfirmationOf)
  end
  
  it "should validate if case sensitive is irrelevent" do
    @it = River.new
    @it.water = 'cold'
    @it.water_confirmation = 'COLD'
    @it.should be_valid
  end
end