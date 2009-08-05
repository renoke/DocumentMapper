require File.dirname(__FILE__) + '/../../spec_helper'


describe DocumentMapper::Agregation::ClassMethods do
  
  before(:all) do
    class Adress < DocumentMapper::Base
      
    end
    
    class Person < DocumentMapper::Base
      aggregate 1, :adress
    end
    
    @it = Person.new
  end
  

  describe 'Single Agregation' do
  
    it "defines an agregate getter method" do
      @it.should respond_to(:adress)
    end
  
  
    it "defines an agregate setter method" do
      @it.should respond_to(:adress=)
    end
  
    it "returns an instance of agregate class" do
      @it.adress.should be_kind_of(Adress)
    end
  
    it "instantiates an agregate class with stored hash" do
      @it['adress'] = {:street=>'Vaya con Dios', :city=>'Angel'}
      @it.adress.street.should == 'Vaya con Dios'
    end
    
    it "uses document to_hash to store value" do
      adress = Adress.new(:foo => 'bar')
      adress.to_hash.should == {'foo'=>'bar'}
    end
  
    it "stores agregate instance as a hash" do
      @it.adress = Adress.new(:road=>'To Hell', :place=>'Earth')
      @it.adress.road.should == 'To Hell'
    end
  
  end
  
end