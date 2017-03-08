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

    # copy = self.copy
    steps = []

    steps += eqns[0].change_subject_to(subject)
    new_eqn = eqns[1].subs_terms(subject,steps.last.rs)
    steps += new_eqn.expand
    next_step = new_eqn.expand.last
    next_step = next_step.change_subject_to('y')
    steps += next_step
    steps = steps.delete_duplicate_steps
  end

  def latex
    result = ''
    eqns.each_with_index do |equation,i|
      result += equation.latex + '&\left(' + (i+1).to_s + '\right)&\\\[5pt]
      '
    end
    result
  end

end
