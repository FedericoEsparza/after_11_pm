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
    steps << eqn(lhs.expand.last.flatit.standardize_add_m_form.simplify_add_m_forms.flatit,rhs)
    steps
  end

  def solve_quad_eqn
    copy = self.copy

    curr_steps = copy.expand_quad_eqn
    next_steps = curr_steps.last.simplify_quad_eqn
    curr_steps += next_steps

    eqn = curr_steps.last.ls


    curr_steps
  end

  def latex_quad_solution
    copy =self.copy
    result = '\begin{align*}
    '
    steps = copy.solve_quad_eqn
    latex_steps = steps.map{|a| a.latex}

    latex_steps.each do |step|
      result += step + '&\\\[5pt]
      '
    end

    quadractic = steps.last.ls.get_quad
    next_latex = quadractic.latex
    next_latex.slice!'\\begin{align*}
    '
    result += next_latex
  end

  def convert_rational_to_quad
    copy = self.copy
    left = ls
    right = rs
    steps = []

    common_denoms = copy.mtp_common_denoms
    simplified = common_denoms.elim_common_factors

    steps = [copy,common_denoms,simplified]
  end

  def latex_rational_to_quad
    copy = self.copy

    steps = copy.convert_rational_to_quad

    result = '\beign{align*}
    '

    steps.each do |step|
      result += step.latex + '&\\\[5pt]'
    end

    result
  end

  def elim_common_factors
    left = ls
    right = rs
    left_args = []
    right_args = []

    if left.is_a?(multiplication)
      left = left.top_heavy.elim_common_factors
    elsif  left.is_a?(fraction)
      left = left.elim_common_factors
    elsif left.is_a?(addition)
      left.args.each do |arg|
        if arg.is_a?(multiplication)
          left_args << arg.top_heavy.elim_common_factors
        elsif arg.is_a?(fraction)
          left_args << arg.elim_common_factors
        else
          left_args << arg
        end
      end
      left = add(left_args)
    end

    if right.is_a?(multiplication)
      right = right.top_heavy.elim_common_factors
    elsif  right.is_a?(fraction)
      right = right.elim_common_factors
    elsif right.is_a?(addition)
      right.args.each do |arg|
        if arg.is_a?(multiplication)
          right_args << arg.top_heavy.elim_common_factors
        elsif arg.is_a?(fraction)
          right_args << arg.elim_common_factors
        else
          right_args << arg
        end
      end
      right = add(right_args)
    end

    eqn(left,right)

  end

  def mtp_common_denoms
    denom_factors = []
    left = ls
    right = rs

    denom_factors = left.find_denoms
    denom_factors += right.find_denoms

    if denom_factors.length == 0
      return self
    else

      left_args = []
      right_args = []
      if ls.is_a?(multiplication)
        left_args = denom_factors + left.args
        left = mtp(left_args).flatit
      elsif ls.is_a?(addition)
        left.args.each{|arg| left_args << mtp(mtp(denom_factors),arg)}
        left = add(left_args).flatit
      else
        left = mtp(mtp(denom_factors),left).flatit
      end

      if rs.is_a?(multiplication)
        right_args = denom_factors + right.args
        right = mtp(right_args).flatit
      elsif rs.is_a?(addition)
        right.args.each{|arg| right_args << mtp(mtp(denom_factors),arg)}
        right = add(right_args).flatit
      else
        right = mtp(mtp(denom_factors),right).flatit
      end
    end

    eqn(left,right)

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
