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

  def generate_solution
    subject = find_subject(eqns[0])
    steps = []

    first_steps = eqns[0].change_subject_to(subject)
    # first_steps.delete_at(-1)
    first_steps = first_steps.delete_duplicate_steps

    new_eqn = eqns[1].subs_terms(subject,first_steps.last.rs)
    sub_steps = new_eqn.expand
    next_step = new_eqn.expand.last
    next_step = next_step.flatit
    next_step = eqn(next_step.ls,next_step.rs.evaluate_numeral)
    next_step = next_step.solve_one_var_eqn
    sub_steps += next_step
    sub_steps = sub_steps.delete_duplicate_steps

    next_subject = sub_steps.last.ls
    second_var = sub_steps.last
    new_value = sub_steps.last.rs
    new_eqn = first_steps.last.copy
    last_steps = new_eqn.subs_terms(next_subject,new_value).expand
    first_var = last_steps.last
    steps = {first: first_steps, sub: sub_steps, last: last_steps,
      first_var: first_var, second_var: second_var}
  end

  def solution_latex
    result = '\begin{align*}
    '
    result += latex
    steps = generate_solution
    steps[:first].delete_at(0)
    result += '&\text{Rearrange (1)}'

    steps[:first].each_with_index do |step,i|

      if i == 0
        result += '&' + step.latex
      else
        result += '&&' + step.latex
      end
      if i ==  steps[:first].length - 1
        result += '&\left(3\right)&\\\[15pt]
        '
      else
        result += '&\\\[5pt]
        '
      end
    end
    result += '&\text{Sub (3) into (2)}'

    steps[:sub].each_with_index do |step,i|
      if i == 0
        result += '&' + step.latex
      else
        result += '&&' + step.latex
      end
      if i == steps[:sub].length - 1
        result += '&\\\[15pt]
        '
      else
        result += '&\\\[5pt]
        '
      end
    end
    result += '&\text{Sub ' + steps[:second_var].ls.latex + ' into (3)}'

    steps[:last].each_with_index do |step,i|
      if i == 0
        result += '&' + step.latex + '&\\\[5pt]
        '
      else
        result += '&&' + step.latex + '&\\\[5pt]
        '
      end
    end

    result += '\end{align*}
    $' + steps[:first_var].ls.latex + '=' + steps[:first_var].rs.latex + '\,\,\,$ and $\,\,\,'
    result += steps[:second_var].ls.latex + '=' + steps[:second_var].rs.latex + '$'
  end

  def latex
    result = ''
    eqns.each_with_index do |equation,i|
      result += '&&' + equation.latex + '&\left(' + (i+1).to_s + '\right)&&&&\\\[5pt]
      '
    end
    result = result.chomp('[5pt]
      ')
    result += '[15pt]
    '
    result
  end

end
