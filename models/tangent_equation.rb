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
    result_1 = []
    upper_limit = options[:ans_max].dup
    lower_limit = options[:ans_min].dup
    range = upper_limit - lower_limit
    max = (range / period).abs + 1
    i = 0

    while i < max
      if upper_limit.negative?
        sol_1 = (-period * i) + set_1.rs

        result_1 << sol_1 unless sol_1 < upper_limit || sol_1.positive?
      else
        sol_1 = (period * i) + set_1.rs

        result_1 << sol_1 unless sol_1 > upper_limit || sol_1.negative?
      end

      i += 1
    end

    solution = result_1
  end
end
