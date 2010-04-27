# encoding: utf-8

require 'complex'
module Symbolic::Constants
  require "#{File.dirname(__FILE__)}/constant.rb"
  if RUBY_VERSION < '1.9'
    PI = Symbolic::Constant.new(::Math::PI,'PI')
    I = Symbolic::Constant.new(::Complex::I,'i')
    E = Symbolic::Constant.new(::Math::E,'e')
  else #we can use unicode
    PI = Symbolic::Constant.new(::Math::PI,'π')
    I = Symbolic::Constant.new(::Complex::I,'ⅈ')
    E = Symbolic::Constant.new(::Math::E,'ⅇ')
  end
end