begin
  require 'couchrest'
rescue
  puts 'You need couchrest gem to use CouchDB KeyValueMapper'
end

module KeyValueMapper
  
  module Adapters
    
    class CouchdbAdapter
      def initialize(options={})
        @database = options[:database]
        @db=CouchRest.database!(@database)
      end
      
      module Write
        
        def create(resources)
          result = @db.save_doc(resources)
          (result["ok"] == true) ? result['id'] : false
        end

        def get(id)
          begin
            result = @db.get(id)
          rescue
            nil
          end
        end

        def update(id, attributes)
          if document = get(id)
            document.merge!(attributes)
            document.save
            document
          end
        end

        def delete(id)
          if document = get(id)
            document.destroy
            document.freeze
          end
        end
        
        def clear
          @db.recreate!
        end
        
      end
      
      module Read
        
        
        def has_view?(name)
          # name has form 'mydesign/myview'
          # so it must have '/' character
          if name =~ /\// 
            splited = name.split('/')
            design  = splited.shift  
            view    = splited.join('/')
            get("_design/#{design}")['views'].has_key?(view)
          else
            nil
          end
        end
        
        
        def read_all(*args)
          query = args.extract_options!
          query.flatten_options
          name = args.first
          case 
          when name == :all || name == :slow || name.nil?
            map = query.delete(:map) || query.delete('map') || "function(doc) {emit(doc._id, doc);}"
            reduce    = query.delete(:reduce) || query.delete('reduce')
            response = @db.slow_view({:map => map, :reduce=>reduce}, query)
          when has_view?(name)
            response  = @db.view(name, query)
          else
            args = args.flatten.compact.uniq
            response  = @db.documents(:keys => args) || {}
          end
            
          return if not_found(response)
          response['rows']
          
        end
        
        def read_one(*args)
          query = args.extract_options!
          name = args.shift || :all
          read_all(name, query.merge(:limit=>1)).first['value']
        end
        
        private
        
        def not_found(response)
          response['rows'].first.nil? || response['rows'].first.has_key?('error')
        end
        
      end
      
      include Write
      include Read
    end
  end
end