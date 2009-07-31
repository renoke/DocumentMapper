module Flat
  
  module CoreMash
    
    def id #:nodoc:
     self["id"] ? self["id"] : super
    end

    # Borrowed from Merb's Mash object.
    #
    # ==== Parameters
    # key<Object>:: The default value for the mash. Defaults to nil.
    #
    # ==== Alternatives
    # If key is a Symbol and it is a key in the mash, then the default value will
    # be set to the value matching the key.
    def default(key = nil) 
     if key.is_a?(Symbol) && key?(key) 
       self[key] 
     else 
       key ? super : super()
     end 
    end



    # Retrieves an attribute set in the Mash. Will convert
    # any key passed in to a string before retrieving.
    def [](key)
     key = convert_key(key)
     regular_reader(key)
    end

    # Sets an attribute in the Mash. Key will be converted to
    # a string before it is set.
    def []=(key,value) #:nodoc:
     key = convert_key(key)
     regular_writer(key,convert_value(value))
    end

    # This is the bang method reader, it will return a new Mash
    # if there isn't a value already assigned to the key requested.
    def initializing_reader(key)
     return self[key] if key?(key)
     self[key] = Flat::Document.new
    end

    alias_method :regular_dup, :dup  
    # Duplicates the current mash as a new mash.
    def dup
     Flat::Document.new(self)
    end


    def key?(key)
     picky_key?(convert_key(key))
    end

    alias_method :regular_inspect, :inspect  
    # Prints out a pretty object-like string of the
    # defined attributes.
    def inspect
     ret = "<#{self.class.to_s}"
     keys.sort.each do |key|
       ret << " #{key}=#{self[key].inspect}"
     end
     ret << ">"
     ret
    end
    alias_method :to_s, :inspect

    # Performs a deep_update on a duplicate of the
    # current mash.
    def deep_merge(other_hash)
     dup.deep_merge!(other_hash)
    end

    # Recursively merges this mash with the passed
    # in hash, merging each hash in the hierarchy.
    def deep_update(other_hash)
     other_hash = other_hash.to_hash if other_hash.is_a?(Flat::Document)
     other_hash = other_hash.stringify_keys
     other_hash.each_pair do |k,v|
       k = convert_key(k)
       self[k] = self[k].to_mash if self[k].is_a?(Hash) unless self[k].is_a?(Flat::Document)
       if self[k].is_a?(Hash) && other_hash[k].is_a?(Hash)
         self[k] = self[k].deep_merge(other_hash[k]).dup
       else
         self.send(k + "=", convert_value(other_hash[k],true))
       end
     end
    end
    alias_method :deep_merge!, :deep_update

    # ==== Parameters
    # other_hash<Hash>::
    # A hash to update values in the mash with. Keys will be
    # stringified and Hashes will be converted to Mashes.
    #
    # ==== Returns
    # Mash:: The updated mash.
    def update(other_hash)
     other_hash.each_pair do |key, value|
       if respond_to?(convert_key(key) + "=")
         self.send(convert_key(key) + "=", convert_value(value))
       else
         regular_writer(convert_key(key), convert_value(value))
       end
     end
     self
    end
    alias_method :merge!, :update

    # Converts a mash back to a hash (with stringified keys)
    def to_hash
     Hash.new(default).merge(self)
    end

    def method_missing(method_name, *args) #:nodoc:
     if (match = method_name.to_s.match(/(.*)=$/)) && args.size == 1
       self[match[1]] = args.first
     elsif (match = method_name.to_s.match(/(.*)\?$/)) && args.size == 0
       key?(match[1])
     elsif (match = method_name.to_s.match(/(.*)!$/)) && args.size == 0
       initializing_reader(match[1])
     elsif key?(method_name)
       self[method_name]
     elsif match = method_name.to_s.match(/^([a-z][a-z0-9A-Z_]+)$/)
       default(method_name)
     else
       super
     end
    end

    protected

    def convert_key(key) #:nodoc:
     key.to_s
    end

    def convert_value(value, dup=false) #:nodoc:
     case value
       when Hash
         value = value.dup if value.is_a?(Flat::Document) && dup
         value.is_a?(Flat::Document) ? value : value.to_mash
       when Array
         value.collect{ |e| convert_value(e) }
       else
         value
     end
    end
   
  end
end