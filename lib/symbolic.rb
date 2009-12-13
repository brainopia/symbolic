Symbolic = Module.new

require 'symbolic/coerced'
require 'symbolic/variable'
require 'symbolic/summand'
require 'symbolic/factor'
require 'symbolic/function'
require 'symbolic/math'
require 'symbolic/statistics'

require 'symbolic/extensions/kernel'
require 'symbolic/extensions/numeric'
require 'symbolic/extensions/matrix' if Object.const_defined? 'Matrix'
require 'symbolic/extensions/rational' if RUBY_VERSION == '1.8.7'

module Symbolic
  def -@
    Factor.multiply self, -1
  end

  def +@
    self
  end

  def +(var)
    Summand.add self, var
  end

  def -(var)
    Summand.subtract self, var
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

  def undefined_variables
    variables.select {|it| it.value.nil? }
  end

  private

  def factors
    [1, { self => 1 }]
  end

  def summands
    [0, { self => 1 }]
  end

  def variables_of(var)
    var.variables rescue []
  end
end