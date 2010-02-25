require File.expand_path('../../spec_helper', __FILE__)

describe Symbolic::Abelian do
  it 'should initialize base and exponent' do
    abelian = Symbolic::Abelian.new :base, :power
    abelian.base.should == :base
    abelian.power.should == :power
  end
end