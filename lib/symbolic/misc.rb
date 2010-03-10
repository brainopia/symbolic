module Symbolic
  def factorial(n)
    (1..n).inject(1){|f,n| f*n}
  end
end