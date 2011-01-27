require File.expand_path('../../spec_helper', __FILE__)

describe Symbolic do
  let(:x) { var :name => :x, :value => 1 }

  it 'variables equality is instance equality' do
    x.should_not == var(:name => :x, :value => 1)
  end

  it 'should be equal (sub-groups)' do
    s = 3 + x
    a = s*3
    b = s*3
    a.should == a
    a.should == b
    b.should == a
  end
end
