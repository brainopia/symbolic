require File.expand_path('../symbolic', __FILE__)

include Symbolic
=begin
one = Abelian.new(1)

e = one + 2 + 3 + 4
p e # => {Summands <Summand 1>, <Summand 2>, <Summand 3>, <Summand 4>}
p e.value # => 10
puts

f = e + 5 # => {Summands <Summand 1>, <Summand 2>, <Summand 3>, <Summand 4>, <Summand 5>}
p f.value # => 15
p e.value # => 10
puts

p e2 = e * 5 # => {Factors {Summands <Summand 1>, <Summand 2>, <Summand 3>, <Summand 4>}, <Factor 5>}
p e2.value # => 50
puts

p e=one - 2 # => {Summands <Summand 1>, <Summand -2>}
p e.value # => -1
puts

p e=one / 3 # => {Factors <Factor 1>, <Factor 1/3>}
p e.value # => (1/3)
puts

x = var name: 'x', value: 2

p e=(x + 2)*3*3 # => {Factors {Summands <Summand x>, <Summand 2>}, <Factor 3>, <Factor 3>}
p e.value # => 36

e.simplify!
p e # => {Factors <Factor 9>, {Summands <Summand x>, <Summand 2>}}
p e.value # => 36
puts

p e=4 + x # => {Summands <Summand 4>, <Summand x>}
p e.value # => 6
puts

p e=x**3 # => {Factors <Factor x ** 3>}
p e.value # => 8
puts

p x**x # => {Factors <Factor x ** x>}
p e= (x**x * 2)**x # => {Factors <Factor x ** {Factors <Factor x>, <Factor x>}>, <Factor 2 ** x>}
p e.value # => 64
=end

x = var :name => 'x', :value => 1
e = -1 * x
p e
