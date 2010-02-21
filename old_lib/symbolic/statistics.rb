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
        else /#{Regexp.escape(op.to_s)}/
        end
        ).size
      })
    }
  end
end