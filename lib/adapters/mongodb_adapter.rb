begin
  require 'mongo'
rescue
  puts 'You need mongodb-mongo gem to use MongoDB DocumentMapper'
end

require File.dirname(__FILE__) + '/../utils/object_id'
include DocumentMapper::Utils

module DocumentMapper
  
  module Adapters
    
    class MongodbAdapter
      
      attr_reader :collection
      
      def initialize(options={})
        @database       = options[:database]
        collection      = options[:collection]
        host            = options[:host] || 'localhost'
        port            = options[:port] || 27017
        @mongo          = XGen::Mongo::Driver::Mongo.new(host, port)
        @db             = @mongo.db(@database)
        @collection     = @db.collection(collection || options[:class]) 
      end
      
      module Write
        
        def create(resources)
          resources[:_id] = DocumentMapper::Utils::ObjectID.new.to_s
          @collection.insert(resources) && resources[:_id]
        end

        def update(id, attributes)
            if object = get(id)
              object.merge!(attributes)
              @collection.replace({:_id => id}, object)
              object
            end
        end

        def delete(id)
          if object = get(id)
            @collection.remove(:_id => id)
            object.freeze
          end
        end
        
        def clear
          @collection.clear
        end
        
      end
      
      module Read
        
        def get(id)
          @collection.find_first(:_id => id)
        end
        
        def read_all(query={})
          options = optionfy(query)
          @collection.find(query,options).entries
        end
        
        def read_first(*query)
          criteria = query.extract_options!
          field = query.shift || 'created_at'
          options = {:limit=>1, :sort=>{"#{field}"=>1}}
          @collection.find(criteria, options).entries[0]
        end
        
        def read_last(*query)
          criteria = query.extract_options!
          field = query.shift || 'created_at'
          options = {:limit=>1, :sort=>{"#{field}"=>-1}}
          @collection.find(criteria, options).entries[0]
        end
        
        def read_ids(*ids)
          ids = ids.flatten.compact.uniq
          @collection.find('_id'=>{'$in'=>ids}).to_a
        end
        
        private
        
        def optionfy(query)
          {
            :limit  => query.delete(:limit) || 0,
            :offset => query.delete(:offset)|| 0,
            :sort   => query.delete(:sort),
            :hint   => query.delete(:hint),
            :fields => query.delete(:fields) || query.delete(:select),
          }
        end
        
      end
      
      include Write
      include Read
    end
  end
end