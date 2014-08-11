require "bundler/setup"

require "active_support"
require "active_support/core_ext/array/grouping"

require "margrid/components"
require "margrid/relation"
require "margrid/grid"
require "margrid/builder"
require "margrid/factory_methods"

module Margrid
  extend FactoryMethods
end
