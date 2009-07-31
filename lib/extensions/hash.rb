
class Hash
# Returns a new Mash initialized from this Hash.
  def to_mash
    mash = KeyValueMapper::Document.new(self)
    mash.default = default
    mash
  end

  # Returns a duplicate of the current hash with
  # all of the keys converted to strings.
  def stringify_keys
    dup.stringify_keys!
  end

  # Converts all of the keys to strings
  def stringify_keys!
    keys.each{|k| 
      v = delete(k)
      self[k.to_s] = v
      v.stringify_keys! if v.is_a?(Hash)
      v.each{|p| p.stringify_keys! if p.is_a?(Hash)} if v.is_a?(Array)
    }
    self
  end
  
  # Borrowed from ActiveSupport
  def assert_valid_keys(*valid_keys)
    unknown_keys = keys - [valid_keys].flatten
    raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(', ')}") unless unknown_keys.empty?
  end
  
  def flatten_options
    if self[:options].is_a?(Hash)
      options = self.delete(:options) 
      self.merge!(options)
    end
  end
end