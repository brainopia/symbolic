#$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.expand_path('../../lib/symbolic', __FILE__)
# require '../lib/symbolic/plugins/autovarname'

# x = var(:x)
# 
# angle = var  'θ'
# p angle*2
# y = var :y
# 
# p 2*x
# 
# p ((x/y)/(x/y))
# p (y/x)/(x/y)
# 
# p (-x**y-4*y*(-2)+5-y/x-x*y).operations

# x = var value: 2
# 
# y = var { x**2 }
# x.value = 3
# p (x*y).value
# z = var
# p (z+1).value

# set_trace_func proc { |event, file, line, id, binding, classname|
#   printf "%8s %12s:%-2d %10s %8s\n", event, File.basename(file, '.rb'), line, id, classname
# }

# def ivars(o)
#    o.instance_variables.
#    map { |ivar| [ivar, o.instance_variable_get(ivar)] }.
#    each_with_object({}) { |ivar, h|
#       var, val = ivar
#       if Hash === val
#          p val.keys.each_with_object({}) { |e, r| r[e] = e.class } # [Symbolic::Summands, Symbolic::Factors].include?
#       end
#       h[var] = val
#    }
# end
# 
# x = var name: :x
# y = var name: :y
# puts

# e =  2 * x**(3+y)# + 5 * (y**(6) + x ** 5)
# p [e, e.class]
# p ivars(e)
# 
# puts

include Symbolic

# 2 + 3*4*5
#p e = Summands.new(2, Factors.new(3, Factors.new(4, 5)))
#p e.value

require 'pp'

two = Summand.new(2)

e = two + 3 + 4
p e
puts

pp e #=>
# #<Symbolic::Summands:0x00000100845db8
#  @members=
#   [#<Symbolic::Summand:0x00000100845e30
#     @base=2,
#     @coef=0,
#     @exp=1,
#     @group=#<Symbolic::Summands:0x00000100845db8 ...>>,
#    #<Symbolic::Summand:0x00000100845d68
#     @base=3,
#     @coef=0,
#     @exp=1,
#     @group=#<Symbolic::Summands:0x00000100845db8 ...>>,
#    #<Symbolic::Summand:0x00000100845cf0
#     @base=4,
#     @coef=0,
#     @exp=1,
#     @group=#<Symbolic::Summands:0x00000100845db8 ...>>]>

puts
p e.value #=> 9

#require 'pp'
#puts
#pp e

#p f = Factor.new(1, 2)
#p f * 3

