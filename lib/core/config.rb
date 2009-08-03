

module DocumentMapper
  
    module Config
    
      def setup(options)
        adapter_string = options[:adapter].to_s
        adapter_file = adapter_string.downcase + '_adapter.rb'
        @adapter_name =  adapter_string.capitalize + 'Adapter'
      
        require_adapter(adapter_file)
        @repository = adapter_class.new(options)
      end
    
      def root
        @root ||= File.expand_path(File.dirname(__FILE__))
      end
    
      def adapter_class
        DocumentMapper::Adapters::const_get(adapter_name)
      end
    
      def adapter_name
        @adapter_name
      end
    
      def repository
        @repository
      end
    
      private
    
      def require_adapter(file_string)
        require root + '/../adapters/' + file_string
      end
    
    end
    
    extend Config
  
end