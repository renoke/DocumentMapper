gem     'extlib', '~>0.9.10'
require 'extlib'

dir = File.expand_path(File.dirname(__FILE__))
require dir + '/adapters/adapter'
require dir + '/extensions/hash'
require dir + '/extensions/array'
require dir + '/config'
require dir + '/core_mash'
require dir + '/crud'
require dir + '/validatable/validatable'

module Flat
  
  class Document < Hash
  
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
    include Extlib::Hook
    include Validatable
    
    register_instance_hooks :save, :destroy
    
  end #class Document
  
end #module Flat




