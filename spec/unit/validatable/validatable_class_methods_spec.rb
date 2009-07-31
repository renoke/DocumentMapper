require File.dirname(__FILE__) + '/../../spec_helper'

describe Validatable::ClassMethods do
  
  before(:all) do
    
    class Ocean < KeyValueMapper::Document
      validates_presence_of :water
    end
    
  end
  it "should return an array of validations" do
    Ocean.validations.should be_a(Array)
    Ocean.validations.first.should be_a(Validatable::ValidatesPresenceOf)
  end
  
  it "should return an array of hooks before validations" do
    Ocean.before_validations.should be_a(Array)
    Ocean.before_validations.should be_empty
  end
end