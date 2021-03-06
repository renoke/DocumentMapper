
module DocumentMapper
  
  class Base < Hash
  
    def initialize(source_hash = nil, &blk)
      deep_update(source_hash) if source_hash
      super(&blk)
    end
    
    def id
      self['_id']
    end
    
    class << self
      alias [] new
      
      def n
        1.0/0
      end
    end  
    
    alias_method :regular_reader, :[]
    alias_method :regular_writer, :[]=
    alias_method :picky_key?,     :key?
    
    include CoreMash
    include Crud
    include Relations::Aggregation
    include Validatable
    
  end 
  
end 




