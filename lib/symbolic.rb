require 'symbolic/operations'

module Symbolic
  include Operations

  def coerce(numeric)
    return Coerced.new(self), numeric
  end

  def operations
    detailed_operations.values.inject(0) {|sum,it| sum + it }
  end
end

require 'symbolic/coerced'
require 'symbolic/variable'
require 'symbolic/function'
require 'symbolic/math'
require 'symbolic/expression'
require 'symbolic/operation'
require 'symbolic/operation/unary'
require 'symbolic/operation/unary/minus'

require 'symbolic/optimization'
require 'symbolic/optimization/base'
require 'symbolic/optimization/addition'
require 'symbolic/optimization/subtraction'
require 'symbolic/optimization/multiplication'
require 'symbolic/optimization/division'

require 'extensions/kernel'
require 'extensions/numeric'
require 'extensions/matrix'