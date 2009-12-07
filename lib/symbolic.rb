Symbolic = Module.new

require 'symbolic/operations'
require 'symbolic/operations/unary'
require 'symbolic/operations/unary/minus'

require 'symbolic/coerced'
require 'symbolic/variable'
require 'symbolic/function'
require 'symbolic/math'
require 'symbolic/expression'

require 'symbolic/optimization'
require 'symbolic/optimization/base'
require 'symbolic/optimization/addition'
require 'symbolic/optimization/subtraction'
require 'symbolic/optimization/multiplication'
require 'symbolic/optimization/division'

require 'extensions/kernel'
require 'extensions/numeric'
require 'extensions/matrix'