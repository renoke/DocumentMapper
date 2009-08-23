require File.dirname(__FILE__) + '/../../spec_helper'

class Adress < DocumentMapper::Base; end

class Telephon < DocumentMapper::Base; end

class Person < DocumentMapper::Base
  aggregate 1, :adress
  aggregate :n, :telephons
end


describe DocumentMapper::Relations::Aggregation::ClassMethods do
  before(:each) do
    @it = Person.new
  end

  context 'Single Aggregation' do
  
    it "defines a getter method" do
      @it.should respond_to(:adress)
    end
  
  
    it "defines a setter method" do
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
      @it.keys.should include('adress')
    end
  
  end
  
  context "Many Aggregation" do
    
    it "defines an aggregate getter method" do
      @it.should respond_to(:telephons)
    end
    
    it "defines an aggregate setter method" do
      @it.should respond_to(:telephons=)
    end
    
    it "returns an array with the getter method" do
      @it.telephons.should be_kind_of(Array)
    end
    
    it "aggregates an array of documents" do
      telephons = [Telephon.new(:mobile=>1234), Telephon.new(:dom=>4321)]
      @it.telephons = telephons
      @it.telephons.size.should == 2
      @it.telephons.first.should be_kind_of(Telephon)
      @it.keys.should include('telephons')
    end
    
    it "aggregate document like an array" do
      @it.telephons<<Telephon.new(:mobile=>1234)
      @it.telephons.push Telephon.new(:house=>1111)
      @it.telephons.size.should == 2
      @it.telephons.first.mobile.should == 1234
      @it.telephons.last.house.should == 1111
      @it.keys.should include('telephons')
      @it.regular_reader('telephons').size.should == 2
      @it.regular_reader('telephons').first.mobile.should == 1234
      @it.regular_reader('telephons').last.house.should == 1111
    end
    
  end
  
end