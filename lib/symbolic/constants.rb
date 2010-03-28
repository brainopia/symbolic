# encoding: utf-8

module Symbolic::Constants
  require "#{File.dirname(__FILE__)}/constant.rb"
  if RUBY_VERSION < '1.9'
    PI = Symbolic::Constant.new(::Math::PI,'PI')
  else
    PI = Symbolic::Constant.new(::Math::PI,'π')
  end
  I = Symbolic::Constant.new(::Complex::I,'i')
end