include Factory
include Latex

class Equation
  include GeneralUtilities
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
end
