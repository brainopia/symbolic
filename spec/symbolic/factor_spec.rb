require File.expand_path('../../spec_helper', __FILE__)

describe Symbolic::Factor do
  it 'should be subclassed from Abelian' do
    Symbolic::Factor.superclass.should == Symbolic::Abelian
  end

  it 'should use identity as exponent by default' do
    summand = Symbolic::Factor.new :base
    summand.base.should == :base
    summand.exponent.should == 1
  end
end