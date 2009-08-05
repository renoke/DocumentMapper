require File.dirname(__FILE__) + '/../../spec_helper'


describe DocumentMapper::Relations::Aggregation::ClassMethods do
  
  before(:all) do
    class Adress < DocumentMapper::Base
      
    end
    
    class Person < DocumentMapper::Base
      aggregate 1, :adress
    end
    
    @it = Person.new
  end
  

  describe 'Single Aggregation' do
  
    it "defines an aggregate getter method" do
      @it.should respond_to(:adress)
    end
  
  
    it "defines an aggregate setter method" do
      @it.should respond_to(:adress=)
    end
  
    it "returns an instance of aggregate class" do
      @it.adress.should be_kind_of(Adress)
    end
  
    it "instantiates an aggregate class with stored hash" do
      @it['adress'] = {:street=>'Vaya con Dios', :city=>'Angel'}
      @it.adress.street.should == 'Vaya con Dios'
    end
    
    it "uses document to_hash to store value" do
      adress = Adress.new(:foo => 'bar')
      adress.to_hash.should == {'foo'=>'bar'}
    end
  
    it "stores aggregate instance as a hash" do
      @it.adress = Adress.new(:road=>'To Hell', :place=>'Earth')
      @it.adress.road.should == 'To Hell'
    end
  
  end
  
end