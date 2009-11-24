require File.expand_path(File.dirname(__FILE__) +'/spec_helper')

describe "Symbolic" do
  def self.x
    var :value => 1, :name => 'x'
  end

  def self.y
    var :value => 2, :name => 'y'
  end

  describe "evaluation (x=1, y=2):" do
    def self.check_evaluation(conditions)
      conditions.each do |symbolic_expression, result|
        it symbolic_expression do
          symbolic_expression.value.should == result
        end
      end
    end

    check_evaluation \
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
    x/2       => 0,
    y/2       => 1,
    x/2.0     => 0.5,
    -2/x      => -2,
    4/(-y)    => -2
  end
end
