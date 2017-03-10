module FactoriseQuadraticEquation
  def _quadratic_infor
    eqn_copy = self.copy

    lft_side_args = ls.is_a?(addition) ? copy.ls.args : [copy.ls]
    rgt_side_args = rs.is_a?(addition) ? copy.rs.args : [copy.rs]

    all_args = lft_side_args + rgt_side_args

    uniques = all_args.inject([]) do |res,arg|
      if arg.is_a?(multiplication)
        arg.args = arg.args.select { |a| numerical?(a) == false }
      end
      if !numerical?(arg.flatten) && !res.include?(arg.flatten)
        res << arg.flatten
      end
      res
    end

    return {is_quadratic?:false,var:nil} unless uniques.length == 2

    check_1 = div(uniques[0].copy,uniques[1].copy).simplify
    return {is_quadratic?:true,var:uniques[1]} if check_1.~(uniques[1])

    check_2 = div(uniques[1].copy,uniques[0].copy).simplify
    return {is_quadratic?:true,var:uniques[0]} if check_2.~(uniques[0])

    return {is_quadratic?:false,var:nil}
  end

  def is_quadratic?
    _quadratic_infor[:is_quadratic?]
  end

  def quadratic_var
    _quadratic_infor[:var]
  end
end
