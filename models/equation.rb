include Factory
include Latex

class Equation
  attr_accessor :ls, :rs

  def initialize(ls,rs)
    @ls = ls
    @rs = rs
  end

  def copy
    if ls.is_a?(string) || numerical?(ls)
      left_side = ls
    else
      left_side = ls.copy
    end
    if rs.is_a?(string) || numerical?(rs)
      right_side = rs
    else
      right_side = rs.copy
    end
    eqn(left_side,right_side)
  end

  def ==(eqn)
    eqn.class == self.class && ls == eqn.ls && rs == eqn.rs
  end

  def solve_one_var_eqn
    #assume left exp, right num and it is one variable
    #reverse the outer most expression until 'x' is left
    curr_steps = [self.copy]
    i = 1
    while (ls.is_a?(string) && numerical?(rs)) == false && i < 100 do
      reverse_last_step(curr_steps)
      evaluate_right_side(curr_steps)
      i += 1
    end
    curr_steps
  end

  def expand_quad_eqn
    right_steps = rs.expand
    left_steps = ls.expand

    steps = [left_steps,right_steps].equalise_array_lengths.transpose
    curr_steps = [self.copy]
    steps.each{|step| curr_steps << eqn(step[0],step[1])}
    curr_steps
  end

#for now, birng everything to the LHS
  def simplify_quad_eqn
    rhs = rs
    lhs = ls

    lhs = add(lhs,mtp(-1,rhs)).flatit
    rhs = 0
    steps = [eqn(lhs,rhs)]
    # steps << [eqn(lhs.simplify_add_m_forms,rhs)]
  end

  def reverse_last_step(curr_steps)
    new_sides = ls.reverse_step(rs)
    self.ls = new_sides[:ls]
    self.rs = new_sides[:rs]
    curr_steps << self.copy
  end

  def evaluate_right_side(curr_steps)
    self.rs = rs.evaluate_numeral
    curr_steps << self.copy
  end

  def latex(no_new_line: false)
    response = ls.latex + '&=' + rs.latex
    # no_new_line ? response : response + '\\\\'
  end
end
