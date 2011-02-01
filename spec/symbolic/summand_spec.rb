require File.expand_path('../../spec_helper', __FILE__)

describe Symbolic::Summand do
  include Symbolic
  it 'be subclassed from Abelian' do
    Summand.superclass.should be Abelian
  end

  it 'use identity as default power' do
    summand = Summand.new :base
    summand.base.should == :base
    summand.power.should == 1
  end

  it 'has the specified power' do
    summand = Summand.new :base, :power
    summand.base.should == :base
    summand.power.should == :power
  end

  it 'keeps that power' do
    x = var :name => 'x', :value => 3
    summand = Summand.new x, 2
    summand.power.should == 2
    summand.value.should == 6
  end
end