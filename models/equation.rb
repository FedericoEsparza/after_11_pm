include Factory
include Latex
include TrigUtilities

class Equation
  attr_accessor :ls, :rs

  def initialize(ls,rs)
    @ls = ls
    @rs = rs
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
    return false unless eqn_1_copy.ls == 0 && eqn_2_copy.ls == 0

    # eqn_1_copy.rs = conventionalise_plus_minus(eqn_1_copy.rs)
    # eqn_2_copy.rs = conventionalise_plus_minus(eqn_2_copy.rs)

    eqn_1_copy.rs = fix_angles_to_x(eqn_1_copy.rs)
    eqn_2_copy.rs = fix_angles_to_x(eqn_2_copy.rs)

    eqn_1_copy.rs = fix_nums_to_one(eqn_1_copy.rs)
    eqn_2_copy.rs = fix_nums_to_one(eqn_2_copy.rs)

    return eqn_1_copy == eqn_2_copy
  end

  def _fix_trig_args

  end

end
