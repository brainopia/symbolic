Symbolic = Module.new

require 'symbolic/operation'
require 'symbolic/operation/binary'
require 'symbolic/operation/binary/addition'
require 'symbolic/operation/binary/subtraction'
require 'symbolic/factor'

require 'symbolic/coerced'
require 'symbolic/variable'
require 'symbolic/function'
require 'symbolic/math'

require 'extensions/kernel'
require 'extensions/numeric'
require 'extensions/matrix' if Object.const_defined? 'Matrix'


module Symbolic
  def -@
    # Operation::Unary::Minus.for self
    Factor.multiply self, -1
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
    Factor.multiply self, var
  end

  def /(var)
    Factor.divide self, var
  end

  def **(var)
    Factor.exponent self, var
  end

  def coerce(numeric)
    return Coerced.new(self), numeric
  end

  def detailed_operations
    formula = to_s
    stats = {}
    stats['+'] = formula.scan(/\+/).size
    stats['-'] = formula.scan(/[^(]-/).size
    stats['*'] = formula.scan(/[^*]\*[^*]/).size
    stats['/'] = formula.scan(/\//).size
    stats['**']= formula.scan(/\*\*/).size
    stats['-@']= formula.scan(/\(-/).size + formula.scan(/^-/).size
    stats
  end

  def operations
    detailed_operations.values.inject(0) {|sum,it| sum + it }
  end

  private

  def factors
    [1, { self => 1 }]
  end
end