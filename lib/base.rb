
module DocumentMapper
  
  class Base < Hash
  
    def initialize(source_hash = nil, &blk)
      deep_update(source_hash) if source_hash
      super(&blk)
    end
    
    def id
      self['_id']
    end
    
    class << self; alias [] new; end  
    
    alias_method :regular_reader, :[]
    alias_method :regular_writer, :[]=
    alias_method :picky_key?, :key?
    
    include CoreMash
    include Crud
    include Agregation
    include Validatable
    
  end 
  
end 




