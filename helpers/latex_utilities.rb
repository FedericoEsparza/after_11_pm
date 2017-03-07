module LatexUtilities
  def brackets(latex_str)
    '\left(' + latex_str + '\right)'
  end

  def period(period_numeric)
    '\pm ' + period_numeric.latex + 'n'
  end

  def add_eq_index(latex:, index:)
    "&(#{index})&" + latex
  end

  def add_columns(num_of_column: 2, latex_array:)
    columns = ' && ' * num_of_column
    first_element_columns = ' && ' * (num_of_column - 1)
    if latex_array.respond_to?(:map)
      latex_array.map { |e| e.map.with_index { |latex, index|
                                               if index == 0
                                                 first_element_columns + \
                                                 latex + \
                                                 first_element_columns
                                               else
                                                 columns + latex + columns
                                               end
                                             }
                      } # [['&& \frac &&'], ['&& x= &&']]
    else
      columns + latex_array + columns
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

  def conventionalise_plus_minus(exp)
    if exp.is_a?(addition)
      if numerical?(exp.args[-1]) && exp.args[-1] < 0
        front_add_args = []
        for k in 0..(exp.args.length-2)
          front_add_args << exp.args[k]
        end
        if front_add_args.length == 1
          return sbt(conventionalise_plus_minus(front_add_args[0]),exp.args[-1].abs)
        end
        if front_add_args.length > 1
          minus_end = conventionalise_plus_minus(add(front_add_args))
          return sbt(minus_end,exp.args[-1].abs)
        end
      end

      if exp.args[-1].is_a?(multiplication) && numerical?(exp.args[-1].args[0]) && exp.args[-1].args[0] < 0
        sub_end = exp.args[-1].copy
        sub_end.args[0] = sub_end.args[0].abs
        front_add_args = []
        for k in 0..(exp.args.length-2)
          front_add_args << exp.args[k]
        end
        if front_add_args.length == 1
          return sbt(front_add_args[0],sub_end)
        end
        if front_add_args.length > 1
          minus_end = conventionalise_plus_minus(add(front_add_args))
          return sbt(minus_end,sub_end)
        end
      end

      if numerical?(exp.args[0]) && exp.args[0] < 0
        exp.args[0] = sbt(nil,exp.args[0].abs)
      end

      for i in 2..(exp.args.length-1)
        if numerical?(exp.args[-i]) && exp.args[-i] < 0
          minus_arg_i = exp.args.length  - i
          new_args = []
          for j in (exp.args.length-i+1)..(exp.args.length-1)
            new_args << exp.args[j]  #check this it needs to be a new copy
          end
          front_add_args = []
          for k in 0..((exp.args.length - i)-1)
            front_add_args << exp.args[k]
          end
          minus_end = conventionalise_plus_minus(add(front_add_args))
          front_sbt = sbt(minus_end,exp.args[-i].abs)
          new_args.insert(0,front_sbt)
          return add(new_args)
        end

        if exp.args[-i].is_a?(multiplication) && numerical?(exp.args[-i].args[0]) && exp.args[-i].args[0] < 0

          minus_arg_i = exp.args.length  - i
          new_args = []
          for j in (exp.args.length-i+1)..(exp.args.length-1)
            new_args << exp.args[j]  #check this it needs to be a new copy
          end
          front_add_args = []
          for k in 0..((exp.args.length - i)-1)
            front_add_args << exp.args[k]
          end
          if front_add_args.length == 1
            minus_end = conventionalise_plus_minus(front_add_args[0])
          else
            minus_end = conventionalise_plus_minus(add(front_add_args))
          end

          exp.args[-i].args[0] = exp.args[-i].args[0].abs

          front_sbt = sbt(minus_end,exp.args[-i])
          new_args.insert(0,front_sbt)
          return add(new_args)
        end
      end

      conv_args = exp.args.inject([]){|r,e| r << conventionalise_plus_minus(e)}
      return exp.class.new(conv_args)
    end

    if exp.is_a?(multiplication) && numerical?(exp.args[0]) && exp.args[0] < 0
      exp.args[0] = exp.args[0].abs
      return sbt(nil,exp)
    end

    if exp.is_a?(multiplication) && !(numerical?(exp.args[0]) && exp.args[0] < 0)
      conv_args = exp.args.inject([]){|r,e| r << conventionalise_plus_minus(e)}
      return exp.class.new(conv_args)
    end

    if exp.is_a?(cosine)
      conv_args = exp.args.inject([]){|r,e| r << conventionalise_plus_minus(e)}
      return exp.class.new(conv_args)
    end

    if exp.is_a?(sine)
      conv_args = exp.args.inject([]){|r,e| r << conventionalise_plus_minus(e)}
      return exp.class.new(conv_args)
    end

    if exp.is_a?(subtraction)
      conv_args = exp.args.inject([]){|r,e| r << conventionalise_plus_minus(e)}
      return exp.class.new(conv_args)
    end

    if exp.is_a?(division)
      conv_args = exp.args.inject([]){|r,e| r << conventionalise_plus_minus(e)}
      return exp.class.new(conv_args)
    end

    if exp.is_a?(power)
      conv_args = exp.args.inject([]){|r,e| r << conventionalise_plus_minus(e)}
      return exp.class.new(conv_args)
    end

    # if numerical?(exp) || exp.is_a?(string)
    return exp
    # end
  end

  def conventionalise_one_times(exp)
    if exp.is_a?(multiplication) && exp.args.length > 1 && exp.args[0] == 1
      exp.args.delete_at(0)
      for i in 0..exp.args.length-1
        conventionalise_one_times(exp.args[i])
      end
      return exp
    end

    if exp.is_a?(addition) || exp.is_a?(subtraction) || exp.is_a?(division) || exp.is_a?(power) || exp.is_a?(cosine) || exp.is_a?(sine)
      for i in 0..exp.args.length-1
        conventionalise_one_times(exp.args[i])
      end
      return exp
    end

    return exp
  end

  def conventionalise(exp)
    conventionalise_one_times(conventionalise_plus_minus(exp))
  end

end
