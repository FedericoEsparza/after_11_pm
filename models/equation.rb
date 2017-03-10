include Factory
include Latex
include TrigUtilities

class Equation
  include GeneralUtilities
  include FactoriseQuadraticEquation
  attr_accessor :args

  def initialize(*args)
    @args = *args
  end

  def ls
    args[0]
  end

  def rs
    args[1]
  end

  def ls=(new_ls)
    args[0] = new_ls
  end

  def rs=(new_rs)
    args[1] = new_rs
  end

  def copy
    DeepClone.clone self
    # if ls.is_a?(string) || numerical?(ls)
    #   left_side = ls
    # else
    #   left_side = ls.copy
    # end
    # if rs.is_a?(string) || numerical?(rs)
    #   right_side = rs
    # else
    #   right_side = rs.copy
    # end
    # eqn(left_side,right_side)
  end

  def ==(eqn)
    eqn.class == self.class && ls == eqn.ls && rs == eqn.rs
  end

  def ~(eqn)
    (eqn.class == self.class && ls.~(eqn.ls) && rs.~(eqn.rs)) || (eqn.class == self.class && eqn.ls.~(self.rs) && eqn.rs.~(self.ls))
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
    steps = steps.delete_duplicate_steps
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

    result = '\begin{align*}
    '

    steps.each do |step|
      result += step.latex + '&\\\[5pt]
      '
    end

    result += '\end{align*}'
  end

  def latex_solve_rational_quad
    result = latex_rational_to_quad.chomp('\end{align*}')
    new_eqn = convert_rational_to_quad.last
    next_steps = new_eqn.latex_quad_solution
    next_steps.slice!('\begin{align*}
    ')
    result += next_steps
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

  def solve_two_var_eqn
    curr_steps = [self.copy]
    i = 1
    while (ls.is_a?(string) && numerical?(rs)) == false && i < 100 do
      reverse_last_step(curr_steps)
      evaluate_right_side(curr_steps)
      i += 1
    end
    curr_steps
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

  # RECURSION
  def fetch(object:)
    object_class = Kernel.const_get(object.to_s.capitalize)
    args.each do |arg|
      if arg.is_a?(Power)
        return arg.args.each { |e|
          return e if e.is_a?(object_class)
        }
      elsif arg.is_a?(self.class)
        return arg.fetch(object: object)
      else
        return arg if arg.is_a?(object_class)
      end
    end
  end

  def reverse_last_subject_step(subject,curr_steps)
    new_sides = ls.reverse_subject_step(subject,rs)
    self.ls = new_sides[:ls]
    self.rs = new_sides[:rs]
    curr_steps << self.copy
  end

  def change_subject_to(subject)
    if ls.contains?(subject)
      curr_steps = [self.copy]
      i = 1
      while !(ls == subject) && i < 100 do
        reverse_last_subject_step(subject,curr_steps)
        i += 1
      end
      curr_steps
    else
      nil
    end
  end

  def contains?(subject)
    ls.contains?(subject) || rs.contains?(subject)
  end

  def find_vars
    vars = ls.find_vars + rs.find_vars
    vars
  end

  def subs_terms(old_var,new_var)
    if self == old_var
      return new_var
    else
      eqn(ls.subs_terms(old_var,new_var),rs.subs_terms(old_var,new_var))
    end
  end

  def expand
    ls_steps = ls.expand
    ls_steps << add(ls_steps.last).flatit.standardize_add_m_form.simplify_add_m_forms
    rs_steps = rs.expand
    rs_steps << add(rs_steps.last).flatit.standardize_add_m_form.simplify_add_m_forms
    steps = [ls_steps,rs_steps].equalise_array_lengths.transpose
    steps.map!{|a| eqn(a.first,a.last)}
    steps = steps.delete_duplicate_steps

  end

  def flatit
    eqn(ls.flatit,rs.flatit)
  end

  def similar_trig_eqn?(eqn_2)
    eqn_1_copy = self.copy
    eqn_2_copy = eqn_2.copy

    return false unless same_angles?(eqn_1_copy.rs) && same_angles?(eqn_2_copy.rs)

    # expand_brackets / multiplication

    eqn_1_copy.rs = fix_angles_to_x(eqn_1_copy.rs)
    eqn_2_copy.rs = fix_angles_to_x(eqn_2_copy.rs)

    eqn_1_copy.rs = fix_nums_to_one(eqn_1_copy.rs)
    eqn_2_copy.rs = fix_nums_to_one(eqn_2_copy.rs)

    # puts eqn_1_copy.rs.latex.shorten
    # puts eqn_2_copy.rs.latex.shorten
    return eqn_1_copy.rs.~(eqn_2_copy.rs)
  end

  def _fix_trig_args

  end
end
