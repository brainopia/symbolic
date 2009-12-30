require 'symbolic/coerced'
require 'symbolic/variable'
require 'symbolic/expression'
require 'symbolic/summands'
require 'symbolic/factors'
require 'symbolic/function'
require 'symbolic/math'
require 'symbolic/statistics'

require 'symbolic/extensions/kernel'
require 'symbolic/extensions/numeric'
require 'symbolic/extensions/matrix' if Object.const_defined? 'Matrix'
require 'symbolic/extensions/rational' if RUBY_VERSION == '1.8.7'

module Symbolic
  def +@
    self
  end

  def -@
    Factors.add self, -1
  end

  def +(var)
    Summands.add self, var
  end

  def -(var)
    Summands.subtract self, var
  end

  def *(var)
    Factors.add self, var
  end

  def /(var)
    Factors.subtract self, var
  end

  def **(var)
    Factors.power self, var
  end

  def coerce(numeric)
    [Coerced.new(self), numeric]
  end

  def inspect
    "Symbolic(#{to_s})"
  end

  private

  def variables_of(var)
    var.variables rescue []
  end
end