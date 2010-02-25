require File.expand_path('../../spec_helper', __FILE__)

describe Symbolic::Numeric do
  it 'should include Symbolic module' do
    Symbolic::Numeric.ancestors.should include(Symbolic)
  end

  it 'should be initialized with value' do
    numeric = Symbolic::Numeric.new :value
    numeric.value.should == :value
  end

  it 'should have a shortcut to initialize new object' do
    numeric = Symbolic::Numeric :value
    numeric.value.should == :value
  end
end