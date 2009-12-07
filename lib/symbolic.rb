module Symbolic
  def self.operations
    { :* => :multiplication,
      :+ => :addition,
      :- => :subtraction,
      :/ => :division }
  end

  operations.each do |sign, name|
    method = <<-CODE
      def #{sign}(value)
        Optimization.#{name} self, value
      end
    CODE
    class_eval method, __FILE__, __LINE__
  end

  def self.math_operations
    [:cos, :sin]
  end

  def -@
    UnaryMinus.create self
  end

  def +@
    self
  end

  def coerce(numeric)
    return Coerced.new(self), numeric
  end

  def undefined?
    !value
  end

  def operations
    detailed_operations.values.inject(0) {|sum,it| sum + it }
  end
end

require 'symbolic/coerced'
require 'symbolic/optimization'
require 'symbolic/optimization/base'
require 'symbolic/optimization/addition'
require 'symbolic/optimization/subtraction'
require 'symbolic/optimization/multiplication'
require 'symbolic/optimization/division'
require 'symbolic/variable'
require 'symbolic/expression'
require 'symbolic/method'
require 'symbolic/unary_minus'

require 'extensions/kernel'
require 'extensions/numeric'
require 'extensions/matrix'