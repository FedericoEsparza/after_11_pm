module FactoriseQuadraticEquation

  def test
    ls
  end

  def factorise_standard_quadractic
    copy = self.copy
    p rs
    quadr = rs.get_quad

    p quadr
    next_step = eqn(0,quadr.brackets_used)
    steps = [copy,next_step]

    factors = quadr.write_factors
    product = quadr.get_method[:Product]
    sum = quadractic.get_method[:Sum]

    {steps: steps, P: product, S: sum, factors: factors}
  end

  def standardize_quadractic(subject)
    copy = self.copy
    new_quad = copy.subs_terms(subject,'x')
    steps = new_quad.convert_rational_steps
    last_step = steps.last.copy
    puts last_step.latex.shorten
    steps += last_step.expand
    last_step = steps.last.copy
    steps += last_step.bring_to_rhs
    next_rs = steps.last.copy.rs.flatit.standardize_add_m_form.simplify_add_m_forms
    steps << eqn(0,next_rs)


    steps = steps.delete_duplicate_steps
    steps = steps.map{|a| a.subs_terms('x',subject)}
  end

  def convert_rational_steps
    copy = self.copy
    steps = [copy]
    last_step = steps.last
    while last_step.find_denoms != []
      denom = last_step.find_denoms.first
      new_sides = []
      last_step.args.each do |side|
        if side.is_a?(addition)
          new_sides << add(side.args.map{|a| mtp(a,denom)}).flatit
        else
          new_sides << mtp(side,denom).flatit
        end
      end
      steps << eqn(new_sides)
      steps << eqn(new_sides).elim_common_factors
      last_step = steps.last
    end
    steps
  end

  def bring_to_rhs
    copy = self.copy
    if ls.is_a?(addition)
      subject = ls.args.last
      steps = copy.change_subject_to(subject)
      last_step = steps.last.copy
      steps += last_step.bring_to_rhs
    else
      steps = [eqn(0,add(rs,mtp(-1,ls).flatit.evaluate_nums))]
    end
  end

  def factorise_quadractic(subject)
    steps = standardize_quadractic(subject)
    quadractic = steps.last.copy
    steps.each{|a| puts a.latex + '\\\[5pt]'}
    p '======================'
    puts steps[-1].latex.shorten
    p steps[-1].rs
    puts quadractic.rs.latex.shorten
    factored_quad = quadractic.factorise_standard_quadractic
    # puts factored_quad[:steps][-1].latex
    factored_quad[:steps] = (steps + factored_quad[:steps]).delete_duplicate_steps

    factored_quad
  end


end
