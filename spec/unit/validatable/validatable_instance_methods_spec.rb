require File.dirname(__FILE__) + '/../../spec_helper'

describe Validatable do
  
  before(:all) do
    
    class Univers < DocumentMapper::Base
      validates_presence_of :earth
    end
    
  end
  it "should respond_to valid?" do
    @it = Univers.new
    @it.should respond_to(:valid?)
  end
end