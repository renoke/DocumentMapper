$TESTING=true

require "rubygems"
require "spec"
require File.dirname(__FILE__)+ "/../document_mapper"
require File.dirname(__FILE__)+ "/../lib/adapters/adapter"

require File.dirname(__FILE__)+ "/models"
require File.dirname(__FILE__)+ "/unit/adapters/adapters_shared"
require File.dirname(__FILE__)+ "/integration/queries_shared"
require File.dirname(__FILE__)+ "/integration/aggregation_shared"

module MockDocument
  
  def setup_instance
   @mash = DocumentMapper::Base.new
   @db = mock(:adapter)
   @mash.stub!(:db).and_return(@db)
 end
 
 def setup_class
   @class = DocumentMapper::Base
   @dbclass = mock(:adapter)
   @class.stub!(:db).and_return(@dbclass)
 end
 
end

module MockDocumentClass
  def setup
    @class = DocumentMapper::Base
    @db = mock(:adapter)
    @class.stub!(:db).and_return(@db)
  end
end




