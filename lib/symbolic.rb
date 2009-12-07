Symbolic = Module.new

require 'symbolic/operation'
require 'symbolic/operation/unary'
require 'symbolic/operation/unary/minus'
require 'symbolic/operation/binary'
require 'symbolic/operation/binary/addition'
require 'symbolic/operation/binary/subtraction'
require 'symbolic/operation/binary/multiplication'
require 'symbolic/operation/binary/division'

require 'symbolic/coerced'
require 'symbolic/variable'
require 'symbolic/function'
require 'symbolic/math'
# require 'symbolic/expression'

# require 'symbolic/optimization'
# require 'symbolic/optimization/base'
# require 'symbolic/optimization/addition'
# require 'symbolic/optimization/subtraction'
# require 'symbolic/optimization/multiplication'
# require 'symbolic/optimization/division'

require 'extensions/kernel'
require 'extensions/numeric'
require 'extensions/matrix'

module Symbolic
  def -@
    Operation::Unary::Minus.for self
  end

  def +@
    self
  end

  def +(var)
    Operation::Binary::Addition.for self, var
  end

  def -(var)
    Operation::Binary::Subtraction.for self, var
  end

  def *(var)
    Operation::Binary::Multiplication.for self, var
  end

  def /(var)
    Operation::Binary::Division.for self, var
  end

  def coerce(numeric)
    return Coerced.new(self), numeric
  end

  def operations
    detailed_operations.values.inject(0) {|sum,it| sum + it }
  end
end