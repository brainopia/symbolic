require File.expand_path('../../spec_helper', __FILE__)

describe Symbolic::Summand do
  it 'should be subclassed from Abelian' do
    Symbolic::Summand.superclass.should == Symbolic::Abelian
  end

  it 'should use identity as exponent by default' do
    summand = Symbolic::Summand.new :base
    summand.base.should == :base
    summand.exponent.should == 0
  end
end