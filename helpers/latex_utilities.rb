module LatexUtilities
  def conv_pm(exp = nil)
    exp = exp.copy || self.copy
    if exp.is_a?(addition) && exp.args.length > 1
      if numerical?(exp.args.last) && exp.args.last < 0
        front_args = exp.args[0..(exp.args.length-2)]
        minus_end = add(front_args).conv_pm
        sub_end = exp.args.last.abs
        return sbt(minus_end,sub_end)
      else
        front_add_args = exp.args[0..(exp.args.length-2)]
        if front_add_args.length == 1
          add_args = front_add_args + [exp.args[-1]]
          return add(add_args)
        else
          add_first_arg = add(front_add_args).conv_pm
          # add_args = [add_first_arg] + [exp.args[-1]]
          # return add(add_args).flatit
          return add(add_first_arg,exp.args[-1]).flatit
        end
      end
    end

    return exp.args.first
  end
    # if exp.is_a?(addition)
    #   if numerical?(exp.args[-1]) && exp.args[-1] < 0
    #     front_add_args = []
    #     for k in 0..(exp.args.length-2)
    #       front_add_args << exp.args[k]
    #     end
    #     minus_end = add(front_add_args).flatten.conv_pm
    #     sub_end = exp.args[-1].abs.conv_pm
    #     return sbt(minus_end,sub_end)
    #   end
    #
    #   if exp.args[-1].is_a?(multiplication) && numerical?(exp.args[-1].args[0]) && exp.args[-1].args[0] < 0
    #
    #     front_add_args = []
    #     for k in 0..(exp.args.length-2)
    #       front_add_args << exp.args[k]
    #     end
    #     minus_end = add(front_add_args).flatten.conv_pm
    #
    #     sub_end = exp.args[-1].copy
    #     sub_end.args[0] = sub_end.args[0].abs
    #     sub_end = sub_end.conv_pm
    #
    #     return sbt(minus_end,sub_end)
    #   end
    #
    #   if numerical?(exp.args[0]) && exp.args[0] < 0
    #     exp.args[0] = sbt(nil,exp.args[0].abs)
    #   end
    #
    #   for i in 2..(exp.args.length-1)
    #     if numerical?(exp.args[-i]) && exp.args[-i] < 0
    #       minus_arg_i = exp.args.length  - i
    #       new_args = []
    #       for j in (exp.args.length-i+1)..(exp.args.length-1)
    #         new_args << exp.args[j]  #check this it needs to be a new copy
    #       end
    #       front_add_args = []
    #       for k in 0..((exp.args.length - i)-1)
    #         front_add_args << exp.args[k]
    #       end
    #       minus_end = conv_pm(add(front_add_args))
    #       front_sbt = sbt(minus_end,exp.args[-i].abs)
    #       new_args.insert(0,front_sbt)
    #       return add(new_args)
    #     end
    #
    #     if exp.args[-i].is_a?(multiplication) && numerical?(exp.args[-i].args[0]) && exp.args[-i].args[0] < 0
    #       # puts "value of i is #{i}"
    #       # p exp.args[-i]
    #       # puts 'hello'
    #       minus_arg_i = exp.args.length  - i
    #       new_args = []
    #       for j in (exp.args.length-i+1)..(exp.args.length-1)
    #         new_args << conv_pm(exp.args[j]) #check this it needs to be a new copy
    #       end
    #       front_add_args = []
    #       for k in 0..((exp.args.length - i)-1)
    #         front_add_args << exp.args[k]
    #       end
    #       if front_add_args.length == 1
    #         minus_end = conv_pm(front_add_args[0])
    #       else
    #         minus_end = conv_pm(add(front_add_args))
    #       end
    #
    #       exp.args[-i].args[0] = exp.args[-i].args[0].abs
    #       exp.args[-i] = conv_pm(exp.args[-i])
    #       # p exp.args[-i]
    #
    #       front_sbt = sbt(minus_end,exp.args[-i])
    #       new_args.insert(0,front_sbt)
    #       # p new_args[0]
    #       return add(new_args)
    #     end
    #   end
    #
    #   conv_args = exp.args.inject([]){|r,e| r << e.conv_pm}
    #   return exp.class.new(conv_args)
    # end
    #
    # if exp.is_a?(multiplication) && numerical?(exp.args[0]) && exp.args[0] < 0
    #   exp.args[0] = exp.args[0].abs
    #   return sbt(nil,exp.conv_pm)
    # end
    #
    # if exp.is_a?(multiplication) && !(numerical?(exp.args[0]) && exp.args[0] < 0)
    #   conv_args = exp.args.inject([]){|r,e| r << e.conv_pm}
    #   return exp.class.new(conv_args)
    # end
    #
    # if _standard_class?(exp)
    #   conv_args = exp.args.inject([]){|r,e| r << e.conv_pm}
    #   return exp.class.new(conv_args)
    # end
    #
    # if numerical?(exp) || exp.is_a?(string)
    #   return exp
    # end
    #
    # if exp.is_a?(square_root)
    #   exp.value = exp.value.conv_pm
    #   return exp
    # end

    # should not have the line below
    # return exp










  # def conv_pm(exp = nil)
  #   exp = exp.copy || self.copy
  #   if exp.is_a?(addition)
  #     if numerical?(exp.args[-1]) && exp.args[-1] < 0
  #       front_add_args = []
  #       for k in 0..(exp.args.length-2)
  #         front_add_args << exp.args[k]
  #       end
  #       minus_end = add(front_add_args).flatten.conv_pm
  #       sub_end = exp.args[-1].abs.conv_pm
  #       return sbt(minus_end,sub_end)
  #     end
  #
  #     if exp.args[-1].is_a?(multiplication) && numerical?(exp.args[-1].args[0]) && exp.args[-1].args[0] < 0
  #
  #       front_add_args = []
  #       for k in 0..(exp.args.length-2)
  #         front_add_args << exp.args[k]
  #       end
  #       minus_end = add(front_add_args).flatten.conv_pm
  #
  #       sub_end = exp.args[-1].copy
  #       sub_end.args[0] = sub_end.args[0].abs
  #       sub_end = sub_end.conv_pm
  #
  #       return sbt(minus_end,sub_end)
  #     end
  #
  #     if numerical?(exp.args[0]) && exp.args[0] < 0
  #       exp.args[0] = sbt(nil,exp.args[0].abs)
  #     end
  #
  #     for i in 2..(exp.args.length-1)
  #       if numerical?(exp.args[-i]) && exp.args[-i] < 0
  #         minus_arg_i = exp.args.length  - i
  #         new_args = []
  #         for j in (exp.args.length-i+1)..(exp.args.length-1)
  #           new_args << exp.args[j]  #check this it needs to be a new copy
  #         end
  #         front_add_args = []
  #         for k in 0..((exp.args.length - i)-1)
  #           front_add_args << exp.args[k]
  #         end
  #         minus_end = conv_pm(add(front_add_args))
  #         front_sbt = sbt(minus_end,exp.args[-i].abs)
  #         new_args.insert(0,front_sbt)
  #         return add(new_args)
  #       end
  #
  #       if exp.args[-i].is_a?(multiplication) && numerical?(exp.args[-i].args[0]) && exp.args[-i].args[0] < 0
  #         # puts "value of i is #{i}"
  #         # p exp.args[-i]
  #         # puts 'hello'
  #         minus_arg_i = exp.args.length  - i
  #         new_args = []
  #         for j in (exp.args.length-i+1)..(exp.args.length-1)
  #           new_args << conv_pm(exp.args[j]) #check this it needs to be a new copy
  #         end
  #         front_add_args = []
  #         for k in 0..((exp.args.length - i)-1)
  #           front_add_args << exp.args[k]
  #         end
  #         if front_add_args.length == 1
  #           minus_end = conv_pm(front_add_args[0])
  #         else
  #           minus_end = conv_pm(add(front_add_args))
  #         end
  #
  #         exp.args[-i].args[0] = exp.args[-i].args[0].abs
  #         exp.args[-i] = conv_pm(exp.args[-i])
  #         # p exp.args[-i]
  #
  #         front_sbt = sbt(minus_end,exp.args[-i])
  #         new_args.insert(0,front_sbt)
  #         # p new_args[0]
  #         return add(new_args)
  #       end
  #     end
  #
  #     conv_args = exp.args.inject([]){|r,e| r << e.conv_pm}
  #     return exp.class.new(conv_args)
  #   end
  #
  #   if exp.is_a?(multiplication) && numerical?(exp.args[0]) && exp.args[0] < 0
  #     exp.args[0] = exp.args[0].abs
  #     return sbt(nil,exp.conv_pm)
  #   end
  #
  #   if exp.is_a?(multiplication) && !(numerical?(exp.args[0]) && exp.args[0] < 0)
  #     conv_args = exp.args.inject([]){|r,e| r << e.conv_pm}
  #     return exp.class.new(conv_args)
  #   end
  #
  #   if _standard_class?(exp)
  #     conv_args = exp.args.inject([]){|r,e| r << e.conv_pm}
  #     return exp.class.new(conv_args)
  #   end
  #
  #   if numerical?(exp) || exp.is_a?(string)
  #     return exp
  #   end
  #
  #   if exp.is_a?(square_root)
  #     exp.value = exp.value.conv_pm
  #     return exp
  #   end
  #
  #   # should not have the line below
  #   # return exp
  # end

  def _standard_class?(exp)
    [power,division,subtraction,sine,cosine,tangent,arcsine,arctangent,arccosine,equation].include?(exp.class)
  end

  def conventionalise_one_times(exp)
    if exp.is_a?(multiplication) && exp.args.length > 1 && exp.args[0] == 1
      exp.args.delete_at(0)
    end
    unless numerical?(exp) || exp.is_a?(string) || exp.nil?
      for i in 0..exp.args.length-1
        conventionalise_one_times(exp.args[i])
      end
    end
    return exp
  end

  def conventionalise(exp)
    conventionalise_one_times(exp.conv_pm)
  end

  def brackets(latex_str)
    '\left(' + latex_str + '\right)'
  end

  def period(period_numeric)
    '\pm ' + period_numeric.latex + 'n'
  end

  def add_eq_index(latex:, index:, side: :left)
    left_side = side == :left ? "&(#{index})&" : ""
    right_side = side == :right ? "&(#{index})&" : ""
    left_side + latex + right_side
  end

  def add_columns(num_of_column: 2, on_right: nil, latex_array:, skip_first: false)
    columns = ' && ' * num_of_column
    right_columns = ' && ' * (on_right || num_of_column)
    first_element_columns = ' && ' * (num_of_column - 1)
    latex_array.class
    if latex_array.respond_to?(:map)
      return latex_array.map do |e|
        if e.respond_to?(:map)
           e.map.with_index do |latex, index|
             if index == 0 && !skip_first
               first_element_columns + \
               latex + \
               first_element_columns
             else
               columns + latex + right_columns
             end
           end
         else
           add_columns(num_of_column: num_of_column, on_right: on_right, skip_first: skip_first,  latex_array: e)
         end
        end # [['&& \frac &&'], ['&& x= &&']]
    else
      columns + latex_array + right_columns
    end
  end

  def add_align_env(latex)
    start = "\\begin{align*}\n"
    align_end = "\n\\end{align*}\n"
    if latex.is_a?(Array)
      latex.map do |solution|
        start + solution + align_end
      end
    else
      start + latex + align_end
    end
  end

end
