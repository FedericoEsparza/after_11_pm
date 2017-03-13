module GeneralUtilities

  def flatten(exp=nil)
    exp = exp || self

    if exp.respond_to?(:args)

      if (exp.is_a?(multiplication) || exp.is_a?(addition)) && exp.args.length == 1
        return flatten(exp.args.first)
      else
        new_args = exp.args.map { |arg| flatten(arg) }
        exp.args = new_args
        return exp
      end
    end

    if numerical?(exp) || exp.is_a?(string)
      return exp
    end
  end

  def write_test(result_steps=[])
    test_string = "expect(result).to eq [\n"
    result_steps.each do |step|
      test_string += "  '" + step.latex.shorten + "'.objectify" + ",\n"
    end
    test_string.slice!(-2)
    test_string += ']'
    test_string
  end

  def is_m_form?(exp)
    return false unless exp.is_a?(multiplication)
    exp.args.each do |arg|
      return false if arg.is_a?(addition) || arg.is_a?(subtraction)
    end
    return true
  end

end
