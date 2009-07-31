$TESTING=true

require "rubygems"
require "spec"
require File.dirname(__FILE__)+ "/../lib/document"
require File.dirname(__FILE__)+ "/../lib/adapters/adapter"

require File.dirname(__FILE__)+ "/unit/adapters/adapters_shared_spec"
require File.dirname(__FILE__)+ "/integration/queries_shared_spec"

module MockDocument
  
  def setup_instance
   @mash = KeyValueMapper::Document.new
   @db = mock(:adapter)
   @mash.stub!(:db).and_return(@db)
 end
 
 def setup_class
   @class = KeyValueMapper::Document
   @dbclass = mock(:adapter)
   @class.stub!(:db).and_return(@dbclass)
 end
 
end

module MockDocumentClass
  def setup
    @class = KeyValueMapper::Document
    @db = mock(:adapter)
    @class.stub!(:db).and_return(@db)
  end
end




