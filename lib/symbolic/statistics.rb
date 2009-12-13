module Symbolic
  def operations
    formula = to_s
    stats = {}
    stats['+'] = formula.scan(/\+/).size
    stats['-'] = formula.scan(/[^(]-/).size
    stats['*'] = formula.scan(/[^*]\*[^*]/).size
    stats['/'] = formula.scan(/\//).size
    stats['**']= formula.scan(/\*\*/).size
    stats['-@']= formula.scan(/\(-/).size + formula.scan(/^-/).size
    stats
  end
end