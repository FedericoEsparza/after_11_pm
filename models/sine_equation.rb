require './models/equation'
require './models/factory'

include Factory

class SineEquation
  attr_accessor :ls, :rs, :options

  def initialize(ls,rs,options={ans_min:0,ans_max:360})
    @ls = ls
    @rs = rs
    @options = options
  end

  def copy
    if ls.is_a?(string) || ls.is_a?(integer)
      left_side = ls
    else
      left_side = ls.copy
    end
    if rs.is_a?(string) || rs.is_a?(integer)
      right_side = rs
    else
      right_side = rs.copy
    end
    sin_eqn(left_side,right_side,options)
  end

  def ==(eqn)
    eqn.class == self.class && ls == eqn.ls && rs == eqn.rs && options = eqn.options
  end

  def solve
    set_1_eqn = eqn(sin(ls),rs)
    set_1_steps = set_1_eqn.solve_one_var_eqn
    set_2_eqn = eqn(sin(sbt(180,ls)),rs)
    set_2_steps = set_2_eqn.solve_one_var_eqn
    {set_1:set_1_steps,set_2:set_2_steps}
  end

end
