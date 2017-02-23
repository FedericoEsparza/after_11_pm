require './models/tangent'
require './models/arc_tangent'
require './models/equation'
require './models/factory'

include Factory

class TangentEquation
  attr_accessor :ls, :rs, :options

  def initialize(ls, rs, options: {ans_min:0, ans_max:360})
    @ls = ls
    @rs = rs
    @options = options
  end

  def copy
    DeepClone.clone self
    # if ls.is_a?(string) || ls.is_a?(integer)
    #   left_side = ls
    # else
    #   left_side = ls.copy
    # end
    # if rs.is_a?(string) || rs.is_a?(integer)
    #   right_side = rs
    # else
    #   right_side = rs.copy
    # end
    # cos_eqn(left_side,right_side,options)
  end

  def ==(eqn)
    eqn.class == self.class && ls == eqn.ls && rs == eqn.rs && options = eqn.options
  end

  def solve
    set_1_eqn = eqn(tan(ls),rs)
    set_1_steps = set_1_eqn.solve_one_var_eqn
    set_1_period = evaluate_period

    solutions = equation_solutions(set_1: set_1_steps.last, period: set_1_period)

    { set_1: { steps: set_1_steps, period: set_1_period },
      solutions: solutions
    }
  end

  def evaluate_period
    return 180 if ls.is_a?(String)
    scalar = nil
    if ls.is_a?(Multiplication) && ls.includes?(String)
      scalar = ls.fetch(object: :numeric)
    else
      ls.args.each do |obj|
        if obj.is_a?(Multiplication) && obj.includes?(String)
          scalar = obj.fetch(object: :numeric)
        end
      end
    end
    (180 / scalar).round(5)
  end

  def equation_solutions(set_1:, period:)
    solution = set_1.rs
    upper_limit = options[:ans_max]
    lower_limit = options[:ans_min]
    range = upper_limit.abs + lower_limit.abs
    max = (range / period).abs.floor + 1
    response = []

    if max == 1
      response << solution
    else
      i = 0
      while i < max
        sol = (upper_limit - (period * i)) + solution

        response << sol if within_limits?(sol)
        i += 1
      end
    end

    response.sort
  end

  def within_limits?(solution)
    solution <= options[:ans_max] && solution >= options[:ans_min]
  end

  def latex_solution
    solution = self.solve
    equation_index = 0
    response = []

    solution.each do |k, v|
      next if k == :solutions
      iteration_array = []
      num_steps = v[:steps].length - 1
      v[:steps].each_with_index do |step, index|
        latex_step = num_steps == index ? step.latex(no_new_line: true) + period(v[:period]) : step.latex
        latex_step = if index == 0
                      equation_index += 1
                      add_eq_index(latex: latex_step, index: equation_index)
                    else
                      latex_step
                    end
        iteration_array << latex_step
      end
      response << iteration_array
    end

    response = add_columns(latex_array: response)
    response = response.map { |e| e.join("\\\\\n") }
    response.unshift(add_columns(latex_array: solution[:set_1][:steps].first.latex))
    response = response.flatten.join("\\\\[10pt]\n")
    response = add_align_env(response)
    response + '$' + solution[:set_1][:steps].last.ls + '=' + ' ' + solution[:solutions].join(',') + '$'
  end
end
