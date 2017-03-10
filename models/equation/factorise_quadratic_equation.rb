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

    uniques = []

    variable_args.each do |var|
      uniques << var unless uniques.include?(var)
    end

    return false unless uniques.length == 2

    check_1 = div(uniques[0].copy,uniques[1].copy).simplify

    if check_1.~(uniques[1])
      return true
    end

    check_2 = div(uniques[1].copy,uniques[0].copy).simplify

    if check_2.~(uniques[0])
      return true
    end

    return false

  end

  def quadratic_var
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

    uniques = []

    variable_args.each do |var|
      uniques << var unless uniques.include?(var)
    end

    return false unless uniques.length == 2

    check_1 = div(uniques[0].copy,uniques[1].copy).simplify

    if check_1.~(uniques[1])
      return uniques[1]
    end

    check_2 = div(uniques[1].copy,uniques[0].copy).simplify

    if check_2.~(uniques[0])
      return uniques[0]
    end

    return nil
  end



end
