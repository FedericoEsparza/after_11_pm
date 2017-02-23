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
end
