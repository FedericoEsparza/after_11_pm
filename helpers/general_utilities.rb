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

  # RECURSION
  def tree_to_array(exp=nil)
    exp = exp || self
    exp = exp.copy
    exp = exp.flatten
    depth = 0
    args_array = []

    if exp.respond_to?(:args)
      exp.args.map do |arg|
        tree_to_array(arg)
      end
    else
      exp
    end
  end

  def depth(exp)
    return 0 if exp.is_a?(String)
    array = exp.is_a?(Array) ? exp : tree_to_array(exp)
    comparison = array.dup
    depth = 1

    until comparison == array.flatten
      depth+=1
      comparison = comparison.flatten(1)
    end

    depth
  end

  # RECURSION
  def includes?(object_class, object: nil)
    object = object || self

    if object.respond_to?(:args)
      object.args.any? do |arg|
        if arg.is_a?(object_class)
          return true
        else
          includes?(object_class, object: arg)
        end
      end
    else
      false
    end
  end
end
