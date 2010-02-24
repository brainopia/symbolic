require File.expand_path('../symbolic', __FILE__)

include Symbolic

one = Abelian.new(1)

e = one + 2 + 3 + 4
p e # => {Summands <Abelian 1>, <Abelian 2>, <Abelian 3>, <Abelian 4>}
p e.value # => 10
puts

f = e + 5 # => {Summands <Abelian 1>, <Abelian 2>, <Abelian 3>, <Abelian 4>, <Abelian 5>}
p f.value # => 15
p e.value # => 10
puts

p e2 = e * 5 # => {Factors {Summands <Abelian 1>, <Abelian 2>, <Abelian 3>, <Abelian 4>}, <Abelian 5>}
p e2.value # => 50
puts

p e=one - 2 # => {Summands <Abelian 1>, <Abelian -2>}
p e.value # => -1
puts

p e=one / 3 # => {Factors <Abelian 1>, <Abelian 1/3>}
p e.value # => (1/3)
puts

x = var name: 'x', value: 2

p e=(x + 2)*3*3 # => {Factors {Summands x, <Abelian 2>}, <Abelian 3>, <Abelian 3>}
p e.value # => 36

e.simplify!
p e # => {Factors <Abelian 9>, {Summands x, <Abelian 2>}}
p e.value # => 36
puts

p e=4 + x # => {Summands <Abelian 4>, x}
p e.value # => 6
puts

p e=x**3 # => {Factors <Abelian x ** 3>}
p e.value # => 8
puts

p x**x # => {Factors <Abelian x ** x>}
p e= (x**x * 2)**x # => {Factors <Abelian x ** {Factors x, x}>, <Abelian 2 ** x>}
p e.value # => 64
