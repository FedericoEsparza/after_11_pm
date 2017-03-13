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

  def trie_depth(exp=nil)
    exp = exp || self
    exp = exp.flatten
    depth = 0
    args_array = []

    if exp.respond_to?(:args)
      exp.args.map do |arg|
        trie_depth(arg)
      end
    else
      exp
    end
  end

  def deep(exp)
    return 0 if exp
    array = exp.is_a?(Array) ? exp : trie_depth(exp)
    count = 0

    array.inject(0) do |total_count, element|
      if element.is_a?(Array)
        element_depth = deep(element)
        total_count += 1
        total_count += element_depth
      end
      if count < total_count
        count = total_count
      end
    end

    count
  end
end
