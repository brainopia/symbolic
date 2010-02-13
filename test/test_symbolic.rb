require "test/unit"
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "symbolic"

class String
  def each(&b)
    each_line(&b)
  end
end

class TestSymbolic < Test::Unit::TestCase
  include Symbolic
  
  def cs(actual, expected = [], expected_value = 0)
    assert_equal(eval(expected.to_s), eval(actual.show.to_s))
    assert_equal(expected_value, actual.value)
  end
  
  def cv(actual, expected = [], expected_value = 0)
    x = var name: 'x', value: 2
    y = var(name: 'y') { x/2 * 3 }
    z = var name: 'z'
    
    assert_equal(eval(expected.to_s), eval(actual.show.to_s))
    assert_equal(expected_value, actual.value)
  end
  
  def test_basic
    # 2 + 3*4*5
    cs Summand.new(2, Factor.new(3, Factor.new(4, 5))), [2, :+, [3, :*, [4, :*, 5]]], 62
    
    cs Summand.new(1, 2) * 3, [3, :*, [1, :+, 2]], 9
    cs Factor.new( 1, 2) * 3, [3, :*, 2], 6
    
    cs Summand.new(2, 3) ** 4, [1, :*, {[2, :+, 3]=>4}], 625
    cs Factor.new( 2, 3) ** 4, [16, :*, {3=>4}], 1296
  end
  
  def test_variable
    x = var name: 'x', value: 2
    y = var(name: 'y') { x/2 * 3 }
    z = var name: 'z'
    
    cv Summand.new(2, y) ** 3, [1, :*, {[2, :+, y]=>3}], 125
    cv Factor.new(2, y) ** 3, [8, :*, {y=>3}], 216
  end
  
  def test_coerce
    cs 4 + Summand.new(2, 3), [4, :+, [2, :+, 3]], 9
    cs 4 + Factor.new( 2, 3), [4, :+, [2, :*, 3]], 10
    
    cs 4 - Summand.new(2, 3), [4, :+, [-2, :+, -3]], -1
    cs 4 - Factor.new( 2, 3), [4, :+, [-2, :*,  3]], -2
  end
end