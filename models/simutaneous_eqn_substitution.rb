include Factory
include Latex

class SimutaneousEqnSubstitution
  attr_accessor :eqns, :vars

  def initialize(*eqns)
    if eqns.length == 1 && eqns[0].class == Array
      @eqns = eqns.first
    else
      @eqns = eqns
    end

    vars = []
    eqns.each{|a| vars += a.find_vars}
    @vars = vars.uniq
  end

  # def copy
  #   new_eqns = eqns.inject([]) do |r,e|
  #     if e.is_a?(string) || numerical?(e)
  #       r << e
  #     else
  #       r << e.copy
  #     end
  #   end
  #   sseqn(new_eqns)
  # end

  def new_eqn
    subject = find_subject(eqns[0])

    sub_eqn = eqns[0].change_subject_to(subject).last.rs

    eqns[1] = eqns[1].subs_terms(subject,sub_eqn)

  end

  def find_subject(equa)
    done = 0
    i = 0
    while done == 0
      if equa.contains?(vars[i])
        done = 1
        return vars[i]
      else
        i += 1
      end
    end
  end

  def solve_eqns
    subject = find_subject(eqns[0])
    steps = []

    first_steps = eqns[0].change_subject_to(subject)
    # first_steps.delete_at(-1)
    first_steps = first_steps.delete_duplicate_steps
    new_eqn = eqns[1].subs_terms(subject,first_steps.last.rs)
    p new_eqn
    sub_steps = new_eqn.expand
    next_step = new_eqn.expand.last
    next_step = next_step.change_subject_to('y')
    sub_steps += next_step
    sub_steps = sub_steps.delete_duplicate_steps
    steps = {first: first_steps, last: sub_steps}
  end

  def solve_eqns_latex
    result = '\begin{align*}
    '
    result += latex
    steps = solve_eqns
    result += '\text{rearrange (1)}\\\[5pt]
    '

    steps[:first].each do |step|
      result += step.latex + '&\\\[5pt]
      '
    end
    result += '\text{sub (1) into (2)}\\\[5pt]'

    steps[:last].each do |step|
      result += '
      ' + step.latex + '&\\\[5pt]'
    end
    result += '
    \end{align*}'
  end

  def latex
    result = ''
    eqns.each_with_index do |equation,i|
      result += equation.latex + '&\left(' + (i+1).to_s + '\right)&&&&\\\[5pt]
      '
    end
    result
  end

end
