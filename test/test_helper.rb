require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'

$: << File.expand_path('../../lib', __FILE__)
require "margrid"

class Margrid::TestCase < Minitest::Test
end

module ActiveRecord
  class Relation; end
end
