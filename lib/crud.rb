module KeyValueMapper
  
  module Crud
    
    module ClassMethods
      
      def db
        KeyValueMapper.repository
      end
    
      def get(id)
        doc = db.get(id)
        doc && KeyValueMapper::Document.new(doc)
      end
    
      def get!(id)
        get(id) || raise(RuntimeError, "Could not find ressource with id #{id}")
      end 
    
      def create(attributes={})
        doc = self.new(attributes)
        doc.save
      end
      
      def all(query={})
        db.read_all(query)
      end
      
      def first(query={})
        new db.read_one(query)
      end
      
      
    end #ClassMethods
         
    module InstanceMethods
         
      def save
        saved = new_record? ? create : update
      end
    
      def destroy
        if db.delete(id)
          #self.freeze
          true
        else
          raise RuntimeError('Could not delete document.')
        end
      end
    
      def new_record?
        !defined?(@new_record) || @new_record
      end
    
      private
    
      def db
        KeyValueMapper.repository
      end
    
      def create
        if id = db.create(self)
          self['_id'] = id
          @new_record = false
          self
        else
          raise RuntimeError('Could not create a new document.')
        end
      end
    
      def update
        if db.update(id,self)
          self
        else
          raise RuntimeError('Could not update the document.')
        end
      end
    
    end #InstanceMethods
    
    include InstanceMethods
    
    def self.included(klass)
      klass.extend(ClassMethods)
    end
    
  end #Crud
  
end #KeyValueMapper