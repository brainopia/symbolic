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

  def undefined?
    !value
  end
end

require 'symbolic/core'
require 'symbolic/optimizations'
require 'symbolic/optimizations/base'
require 'symbolic/optimizations/addition'
require 'symbolic/optimizations/subtraction'
require 'symbolic/optimizations/multiplication'
require 'symbolic/optimizations/division'
require 'symbolic/variable'
require 'symbolic/expression'
require 'symbolic/method'
require 'symbolic/unary_minus'

require 'extensions/kernel'
require 'extensions/numeric'
require 'extensions/matrix'