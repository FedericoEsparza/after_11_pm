module FactoriseQuadraticEquation
  def is_quadratic?
    eqn_copy = self.copy

    left_side_args = []
    if ls.is_a?(addition)
      left_side_args = copy.ls.args
    else
      left_side_args = [copy.ls]
    end

    right_side_args = []
    if rs.is_a?(addition)
      right_side_args = copy.rs.args
    else
      right_side_args = [copy.rs]
    end

    all_args = left_side_args + right_side_args

    all_args.each do |arg|
      if arg.is_a?(multiplication)
        new_args = arg.args.select do |a|
          numerical?(a) == false
        end
        arg.args = new_args
      end
    end

    all_args = all_args.map do |arg|
      arg.flatten
    end

    variable_args = all_args.select do |arg|
      numerical?(arg) == false
    end

    variable_args
    


  end



end
