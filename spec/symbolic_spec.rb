require File.expand_path('../spec_helper', __FILE__)

describe Symbolic do
  before(:all) do
    @var = Object.new
    @var.extend Symbolic
  end

  it 'should handle unary plus' do
    (+@var).should == @var
  end

  it 'should handle unary minus' do
    Symbolic::Factors.should_receive(:add).with(@var, -1).and_return(:negative_value)
    (-@var).should == :negative_value
  end
end
