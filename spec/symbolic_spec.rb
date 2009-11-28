require File.expand_path(File.dirname(__FILE__) +'/spec_helper')

describe "Symbolic" do
  before(:all) do
    @x = var :name => :x, :value => 1
    @y = var :name => :y, :value => 2
  end

  def expression(string)
    eval string.gsub(/[a-z]+/, '@\0')
  end

  describe "evaluation (x=1, y=2):" do
     def self.should_evaluate_to(conditions)
       conditions.each do |symbolic_expression, result|
         it symbolic_expression do
           expression(symbolic_expression).value.should == result
         end
       end
     end

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
     'x/2'       => 0,
     'y/2'       => 1,
     'x/2.0'     => 0.5,
     '-2/x'      => -2,
     '4/(-y)'    => -2
   end

  describe "optimization:" do
    def self.should_equal(conditions)
      conditions.each do |non_optimized, optimized|
        it non_optimized do
          expression(non_optimized).should == expression(optimized)
        end
      end
    end

    should_equal \
    '-(-x)'       => 'x',

    '0 + x'       => 'x',
    'x + 0'       => 'x',
    'x + (-2)'    => 'x - 2',
    '-2 + x'      => 'x - 2',
    '-x + 2'      => '2 - x',
    'x + (-y)'    => 'x - y',
    '-y + x'      => 'x - y',
    '-y + (-x)'   => '-(y + x)',

    '0 - x'       => '-x',
    'x - 0'       => 'x',
    'x - (-2)'    => 'x + 2',
    # '-2 - (-x)'   => 'x - 2',
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

    'x / 1'       => 'x'
  end

  describe "formulas" do
  end
end
