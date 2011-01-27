#!/usr/bin/env ruby -w
require File.expand_path('../spec_helper', __FILE__)

describe Symbolic do
  describe "evaluation (x=1, y=2):" do
    x = var :name => :x, :value => 1
    y = var :name => :y, :value => 2
    {
      x         => 1,
      y         => 2,
      +x        => 1,
      -x        => -1,
      x + 4     => 5,
      3 + x     => 4,
      x + y     => 3,
      x - 1     => 0,
      1 - x     => 0,
      x - y     => -1,
      -x + 3    => 2,
      -y - x    => -3,
      x*3       => 3,
      4*y       => 8,
      (+x)*(-y) => -2,
      x/2       => 0.5,
      y/2       => 1,
      -2/x      => -2,
      4/(-y)    => -2,
      x**2      => 1,
      4**y      => 16,
      y**x      => 2
    }.each_pair { |expr, value|
      it expr do
        expr.value.should == value
      end
    }
  end

  describe "optimization:" do
    x = var :name => :x
    y = var :name => :y
    {
      -(-x)       => x,

      0 + x       => x,
      x + 0       => x,
      x + (-2)    => x - 2,
      -2 + x      => x - 2,
      -x + 2      => 2 - x,
      x + (-y)    => x - y,
      -y + x      => x - y,

      0 - x       => -x,
      x - 0       => x,
      x - (-2)    => x + 2,
      -2 - (-x)   => x - 2,
      x - (-y)    => x + y,

      0 * x       => 0,
      x * 0       => 0,
      1 * x       => x,
      x * 1       => x,
      -1 * x      => -x,
      x * (-1)    => -x,
      x * (-3)    => -(x*3),
      -3 * x      => -(x*3),
      -3 * (-x)   => x*3,
      x*(-y)      => -(x*y),
      -x*y        => -(x*y),
      (-x)*(-y)   => x*y,

      0 / x       => 0,
      x / 1       => x,

      0**x        => 0,
      1**x        => 1,
      x**0        => 1,
      x**1        => x,
      (-x)**1     => -x,
      (-x)**2     => x**2,
      (x**2)**y   => x**(2*y),

      x*4*x       => 4*x**2,
      x*(-1)*x**(-1) => -1,
      x**2*(-1)*x**(-1) => -x,
      x + y - x => y,
      2*x + x**1 - y**2/y - y => 3*x - 2*y,
      -(x+4) => -x-4,

      (x/y)/(x/y) => 1,
      (y/x)/(x/y) => y**2/x**2
    }.each_pair { |non_optimized, optimized|
      it non_optimized do
        non_optimized.should == optimized
      end
    }
  end

  describe 'Variable methods:' do
    let(:v) { var :name => :v }
    let(:x) { var :name => :x, :value => 2 }
    let(:y) { var :name => :y }

    #initialize
    it 'var(:name => :v)' do
      v.name.should == 'v'
      v.value.should be nil
    end
    it 'var.to_s == "unnamed_variable"' do
      v.name = nil
      v.to_s.should == 'unnamed_variable'
      v.value.should be nil
    end
    it 'var init' do
      x.value.should == 2
    end
    it 'proc value' do
      y = var { x**2 }
      x.value = 3
      (x*y).value.should == 27
    end

    it 'expression variables' do
      x.variables.should == [x]
      (-(x+y)).variables.should == [x,y]
    end

    it 'operations' do
      (-x**y-4*y+5-y/x).operations.should == {:+ => 1, :- => 2, :* => 1, :/ => 1, :-@ => 1, :** => 1}
    end

    it 'math method' do
      cos = Symbolic::Math.cos(x)
      x.value = 0
      cos.value.should == 1.0
      cos.to_s.should == 'cos(x)'
    end
  end

  describe "to_s:" do
    x = var :name => :x
    y = var :name => :y
    {
      x                 => 'x',
      -x                => '-x',
      x+1               => 'x+1',
      x-4               => 'x-4',
      -x-4              => '-x-4',
      -(x+y)            => '-x-y',
      -(x-y)            => '-x+y',
      x*y               => 'x*y',
      (-x)*y            => '-x*y',
      (y+3)*(x+2)*4     => '4*(y+3)*(x+2)',
      4/x               => '4/x',
      2*x**(-1)*y**(-1) => '2/(x*y)',
      (-(2+x))/(-(-y))  => '(-x-2)/y',
      x**y              => 'x**y',
      x**(y-4)          => 'x**(y-4)',
      (x+1)**(y*2)      => '(x+1)**(2*y)',
      -(x**y-2)+5       => '-x**y+7'
    }.each_pair { |expr, str|
      it str do
        expr.to_s.should == str
      end
    }
  end
end

describe "Symbolic plugins" do
  if RUBY_VERSION > '1.9' # Not yet compatible with 1.8
    describe "var_name" do
      require "symbolic/plugins/var_name"
      it 'single variable' do
        x = var
        x.name.should == 'x'
      end

      it 'single variable with value' do
        x = var :value => 7
        x.name.should == 'x'
        x.value.should == 7
      end

      it 'multiple variables' do
        x, yy, zzz = vars
        [x, yy, zzz].map(&:name).should == ['x', 'yy', 'zzz']
      end
    end
  end
end