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

  def conventionalise(exp)
    if exp.is_a?(addition)
      if numerical?(exp.args[-1]) && exp.args[-1] < 0
        front_add_args = []
        for k in 0..(exp.args.length-2)
          front_add_args << exp.args[k]
        end
        if front_add_args.length == 1
          return sbt(front_add_args[0],exp.args[-1].abs)
        end
        if front_add_args.length > 1
          minus_end = conventionalise(add(front_add_args))
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
          minus_end = conventionalise(add(front_add_args))
          return sbt(minus_end,sub_end)
        end
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
          minus_end = conventionalise(add(front_add_args))
          front_sbt = sbt(minus_end,exp.args[-i].abs)
          new_args.insert(0,front_sbt)
          return add(new_args)
        end
      end
      return exp
    end
  end

end
