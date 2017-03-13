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

  def delete_nils(exp=nil)
    exp = exp || self

    i = 1
    while i <= exp.args.length do
      if exp.args[i-1]==nil
        delete_arg(i)
      end
      i += 1
    end
    exp.args
  end
end
