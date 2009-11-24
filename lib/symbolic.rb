module Symbolic
  def self.operations
    { :* => :multiplication,
      :+ => :addition,
      :- => :subtraction }
  end

  def self.math_operations
    [:cos, :sin]
  end
end

require 'symbolic/core'
require 'symbolic/operatable'
require 'symbolic/optimizations'
require 'symbolic/variable'
require 'symbolic/expression'
require 'symbolic/method'
require 'symbolic/unary_minus'
require 'extensions/kernel'