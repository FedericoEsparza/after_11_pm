module LatexUtilities
  def conv_pm(exp = nil)
    exp = exp.copy || self.copy
    #ordered if statements
    if exp.is_a?(addition) && exp.args.length > 1
      first_parts = add(exp.args[0..(exp.args.length-2)]).flatten.conv_pm
      last_arg = exp.args.last

      if numerical?(last_arg) && last_arg < 0
        last_arg = last_arg.abs
        last_part = last_arg.conv_pm
        return sbt(first_parts,last_part)
      end

      if last_arg.is_a?(multiplication) && numerical?(last_arg.args.first) && last_arg.args.first < 0
        last_arg.args[0] = last_arg.args[0].abs
        last_part = last_arg.conv_pm
        return sbt(first_parts,last_part)
      end

      last_part = last_arg.conv_pm

      if first_parts.is_a?(addition)
        add_args = first_parts.args + [last_part]
        return add(add_args)
      end

      return add(first_parts,last_part)
    end

    if numerical?(exp) && exp < 0
      return sbt(nil,exp.abs)
    end

    if exp.is_a?(multiplication) && numerical?(exp.args.first) && exp.args.first < 0
      exp.args[0] = exp.args[0].abs
      return sbt(nil,exp)
    end

    if !(exp.nil?) && exp.is_a?(addition) == false && !(numerical?(exp) || exp.is_a?(string))
      conv_args = exp.args.inject([]){|r,e| r << e.conv_pm}
      return exp.class.new(conv_args)
    end

    return exp
  end

  def conv_ones(exp)
    if exp.is_a?(multiplication) && exp.args.length > 1 && exp.args[0] == 1
      exp.args.delete_at(0)
    end
    unless numerical?(exp) || exp.is_a?(string) || exp.nil?
      for i in 0..exp.args.length-1
        conv_ones(exp.args[i])
      end
    end
    return exp
  end

  def conventionalise(exp)
    conv_ones(exp.conv_pm)
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
