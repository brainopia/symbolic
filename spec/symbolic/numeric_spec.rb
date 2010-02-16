require File.expand_path('../../spec_helper', __FILE__)

describe Symbolic::Numeric do
  it 'should be initialized with value' do
    numeric = Symbolic::Numeric.new :value
    numeric.should == :value
  end

  it 'should have a shortcut to initialize new object' do
    numeric = Symbolic::Numeric :value
    numeric.should == :value
  end

  it 'should return an empty array when asked for variables' do
    numeric = Symbolic::Numeric.new :value
    numeric.variables == []
  end
end