class Equation
  attr_accessor :ls, :rs

  def initialize(ls,rs)
    @ls = ls
    @rs = rs
  end

  def solve_one_var_eqn
    #assume left exp, right num and it is one variable
    #reverse the outer most expression until 'x' is left
    if ls.is_a?(multiplication)
      reverse = something
    end
  end

end
