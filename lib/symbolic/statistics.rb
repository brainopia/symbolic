module Symbolic
  OPERATIONS = [:+, :-, :*, :/, :**, :-@]
  def operations
    formula = to_s
    OPERATIONS.inject({}) { |stats, op|
      stats.merge({
        op => formula.scan(
        case op
        when :-  then /[^(]-/
        when :*  then /[^*]\*[^*]/
        when :-@ then /\(-|^-/
        else /#{Regexp.escape(op)}/
        end
        ).size
      })
    }
  end
end