require File.expand_path('../../spec_helper', __FILE__)

describe Symbolic do
  include Symbolic
  before(:all) do
    @x = var :name => :x, :value => 1
    @y = var :name => :y, :value => 2
  end
  
  it "should be equal (number part)" do
    a = Abelian.new(rand)
    b = Abelian.new(a.base)
    a.should == a
    a.should == b
    (-a).should == -b
    
    Summands.new(a).should == Summands.new(b)
    
    (a * 3).should == (b * 3)
    (3+a).should == (3+b)
    #(a + 2).should == (2 + b)
    (3*a + 2).should == (3*b + 2)
  end
  
  it "should be equal (var part)" do
    x = var :name => :x
    x2 = var :name => :x
    
    x.should == x2
    (2*x).should == 2*x2
    (3*x+5).should == (3*x2+5)
    
    (x + (-2)).should == (x2 + (-2))
    
  end
  
  it "should be equal (sub-group part)" do
    x = var :name => 'x'
    s = 3 + x
    f_s = s * 3
    f_s2 = s*3
    f_s.should == f_s
    f_s.should == f_s2
  end
end
