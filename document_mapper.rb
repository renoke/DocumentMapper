#require 'rubygems'
require 'active_support/inflector'

dir = File.expand_path(File.dirname(__FILE__)) + '/lib'
require dir + '/adapters/adapter'
require dir + '/extensions/hash'
require dir + '/extensions/array'
require dir + '/core/config'
require dir + '/core/core_mash'
require dir + '/core/crud'
require dir + '/relations/relation'
require dir + '/relations/aggregation'
require dir + '/validatable/validatable'

require dir + '/base'




