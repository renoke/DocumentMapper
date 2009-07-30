$TESTING=true

require "rubygems"
require "spec"
require File.dirname(__FILE__)+ "/../lib/mash"
require File.dirname(__FILE__)+ "/../lib/adapters/adapter"

require File.dirname(__FILE__)+ "/unit/adapters/adapters_shared_spec"
require File.dirname(__FILE__)+ "/integration/queries_shared_spec"

module MockMash
  
  def setup_instance
   @mash = FlatDoc::Mash.new
   @db = mock(:adapter)
   @mash.stub!(:db).and_return(@db)
 end
 
 def setup_class
   @class = FlatDoc::Mash
   @dbclass = mock(:adapter)
   @class.stub!(:db).and_return(@dbclass)
 end
 
end

module MockMashClass
  def setup
    @class = FlatDoc::Mash
    @db = mock(:adapter)
    @class.stub!(:db).and_return(@db)
  end
end




