#!/usr/bin/env ruby -w
require File.expand_path('../spec_helper', __FILE__)

describe "Symbolic" do
  before(:all) do
    @x = var :name => :x, :value => 1
    @y = var :name => :y, :value => 2
  end

  def expression(string)
    eval string.gsub(/[xy]/, '@\0')
  end

  def self.should_equal(conditions)
    conditions.each do |non_optimized, optimized|
      it non_optimized do
        expression(non_optimized).should == expression(optimized)
      end
    end
  end

  def self.should_evaluate_to(conditions)
    conditions.each do |symbolic_expression, result|
      it symbolic_expression do
        expression(symbolic_expression).value.should == result
      end
    end
  end

  def self.should_print(conditions)
    conditions.each do |symbolic_expression, result|
      it symbolic_expression do
        expression(symbolic_expression).to_s.should == result
      end
    end
  end

  describe "evaluation (x=1, y=2):" do
    should_evaluate_to \
    'x'         => 1,
    'y'         => 2,
    '+x'        => 1,
    '-x'        => -1,
    'x + 4'     => 5,
    '3 + x'     => 4,
    'x + y'     => 3,
    'x - 1'     => 0,
    '1 - x'     => 0,
    'x - y'     => -1,
    '-x + 3'    => 2,
    '-y - x'    => -3,
    'x*3'       => 3,
    '4*y'       => 8,
    '(+x)*(-y)' => -2,
    'x/2'       => 0.5,
    'y/2'       => 1,
    '-2/x'      => -2,
    '4/(-y)'    => -2,
    'x**2'      => 1,
    '4**y'      => 16,
    'y**x'      => 2
  end

  describe "optimization:" do
    should_equal \
    '-(-x)'       => 'x',

    '0 + x'       => 'x',
    'x + 0'       => 'x',
    'x + (-2)'    => 'x - 2',
    '-2 + x'      => 'x - 2',
    '-x + 2'      => '2 - x',
    'x + (-y)'    => 'x - y',
    '-y + x'      => 'x - y',

    '0 - x'       => '-x',
    'x - 0'       => 'x',
    'x - (-2)'    => 'x + 2',
    '-2 - (-x)'   => 'x - 2',
    'x - (-y)'    => 'x + y',

    '0 * x'       => '0',
    'x * 0'       => '0',
    '1 * x'       => 'x',
    'x * 1'       => 'x',
    '-1 * x'      => '-x',
    'x * (-1)'    => '-x',
    'x * (-3)'    => '-(x*3)',
    '-3 * x'      => '-(x*3)',
    '-3 * (-x)'   => 'x*3',
    'x*(-y)'      => '-(x*y)',
    '-x*y'        => '-(x*y)',
    '(-x)*(-y)'   => 'x*y',

    '0 / x'       => '0',
    'x / 1'       => 'x',

    '0**x'        => '0',
    '1**x'        => '1',
    'x**0'        => '1',
    'x**1'        => 'x',
    '(-x)**1'     => '-x',
    '(-x)**2'     => 'x**2',
    '(x**2)**y'   => 'x**(2*y)',

    'x*4*x'       => '4*x**2',
    'x*(-1)*x**(-1)' => '-1',
    'x**2*(-1)*x**(-1)' => '-x',
    'x + y - x' => 'y',
    '2*x + x**1 - y**2/y - y' => '3*x - 2*y',
    '-(x+4)' => '-x-4',

    '(x/y)/(x/y)' => '1',
    '(y/x)/(x/y)' => 'y**2/x**2'
  end

  describe 'Variable methods:' do
    #initialize
    it 'var(:name => :v)' do
      v = var(:name => :v)
      [v.name, v.value].should == ['v', nil]
    end
    it 'var.to_s == "unnamed_variable"' do
      v = var :name => nil # This is because it will auto add a name with the plugin 'autovarname'
      [v.to_s, v.value].should == ["unnamed_variable", nil]
    end
    it 'var init' do
      v = var(:name => :x, :value => 2)
      [v.name, v.value].should == ['x', 2]
    end
    it 'proc value' do
      x = var :name => :x, :value => 2
      y = var { x**2 }
      x.value = 3
      (x*y).value.should == 27
    end

    x, y = var(:name => :x), var(:name => :y)
    #variables
    it 'expression variables' do
      x.variables.should == [x]
    end
    it 'expression variables' do
      (-(x+y)).variables.should == [x,y]
    end

    #operations
    it 'operations' do
      (-x**y-4*y+5-y/x).operations.should == {:+ => 1, :- => 2, :* => 1, :/ => 1, :-@ => 1, :** => 1}
    end

    it 'math method' do
      cos = Symbolic::Math.cos(x)
      x.value = 0
      [cos.value, cos.to_s].should == [1.0, 'cos(x)']
    end
  end

  describe "to_s:" do
    should_print \
    'x' => 'x',
    '-x' => '-x',
    'x+1' => 'x+1',
    'x-4' => 'x-4',
    '-x-4' => '-x-4',
    '-(x+y)' => '-x-y',
    '-(x-y)' => '-x+y',
    'x*y' => 'x*y',
    '(-x)*y' => '-x*y',
    '(y+3)*(x+2)*4' => '4*(y+3)*(x+2)',
    '4/x' => '4/x',
    '2*x**(-1)*y**(-1)' => '2/(x*y)',
    '(-(2+x))/(-(-y))' => '(-x-2)/y',
    'x**y' => 'x**y',
    'x**(y-4)' => 'x**(y-4)',
    '(x+1)**(y*2)' => '(x+1)**(2*y)',
    '-(x**y -2)+5' => '-x**y+7'
  end
end

describe "Symbolic plugins" do
  describe "autovarname" do
    require "symbolic/plugins/autovarname"
    it 'single variable' do
      x = var
      x.name.should == 'x'
    end
    
    it 'single variable with value' do
      x = var :value => 7
      [x.name, x.value].should == ['x', 7]
    end
    
    it 'multiple variables' do
      x, yy, zzz = vars
      [x.name, yy.name, zzz.name].should == ['x', 'yy', 'zzz']
    end
  end
end