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
      
      FINDER_OPTIONS = {:less => '$lt', :less_or_equal =>'$lte'}
      
      def initialize(options={})
        @database       = options[:database]
        collection      = options[:collection]
        host            = options[:host] || 'localhost'
        port            = options[:port] || 27017
        @mongo          = XGen::Mongo::Driver::Mongo.new(host, port)
        @db             = @mongo.db(@database)
        @collection     = @db.collection(collection)
      end
      
      module Write
        
        def create(resources)
          resources[:_id] = DocumentMapper::Utils::ObjectID.new.to_s
          @collection.insert(resources) && resources[:_id]
        end

        def get(id)
          @collection.find_first(:_id => id)
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
        
        def read_all(query={})
          query_options = {
            :limit  => query.delete(:limit) || 0,
            :offset => query.delete(:offset)|| 0,
            :sort   => query.delete(:sort),
            :hint   => query.delete(:hint),
            :fields => query.delete(:fields) || query.delete(:select)
          }
          @collection.find(query,query_options).entries
        end
        
        def read_one(query={})
          options = query.delete(:options) || {}
          @collection.find_first(query, options)
        end
        
        def read_ids(*ids)
          ids = ids.flatten.compact.uniq
          @collection.find('_id'=>{'$in'=>ids}).to_a
        end
        
      end
      
      include Write
      include Read
    end
  end
end