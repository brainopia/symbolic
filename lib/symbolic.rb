module Symbolic
  def self.operations
    { :* => :multiplication,
      :+ => :addition,
      :- => :subtraction,
      :/ => :division }
  end

  def self.math_operations
    [:cos, :sin]
  end
end

require 'symbolic/core'
require 'symbolic/operatable'
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