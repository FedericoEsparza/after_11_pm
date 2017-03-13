include Factory
include Latex

class SimutaneousEqnSubstitution
  attr_accessor :args, :vars

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.flatten
    else
      @args = args
    end

    vars = []
    @args.each { |a|
      vars += a.find_vars }
    @vars = vars.uniq
  end

  # def copy
  #   new_args = args.inject([]) do |r,e|
  #     if e.is_a?(string) || numerical?(e)
  #       r << e
  #     else
  #       r << e.copy
  #     end
  #   end
  #   sseqn(new_args)
  # end

  def new_eqn
    subject = find_subject(args[0])

    sub_eqn = args[0].change_subject_to(subject).last.rs

    args[1] = args[1].subs_terms(subject,sub_eqn)
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
    subject = find_subject(args[0])
    steps = []

    first_steps = args[0].change_subject_to(subject)
    # first_steps.delete_at(-1)
    first_steps = first_steps.delete_duplicate_steps

    new_eqn = args[1].subs_terms(subject,first_steps.last.rs)
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
    result = '\begin{align*}' + "\n"
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
        result += '&\left(3\right)\\\[15pt]' + "\n"
      else
        result += '&\\\[5pt]' + "\n"
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
        result += '&\\\[15pt]' + "\n"
      else
        result += '&\\\[5pt]' + "\n"
      end
    end
    result += '&\text{Sub ' + steps[:second_var].ls.latex + ' into (3)}'

    steps[:last].each_with_index do |step,i|
      if i == 0
        result += '&' + step.latex + '&\\\[5pt]' + "\n"
      else
        result += '&&' + step.latex + '&\\\[5pt]' + "\n"
      end
    end

    result += '\end{align*}' + "\n" + \
    '$' + steps[:first_var].ls.latex + '=' + steps[:first_var].rs.latex + '\,\,\,$ and $\,\,\,'
    result += steps[:second_var].ls.latex + '=' + steps[:second_var].rs.latex + '$'
  end

  def latex
    result = ''
    args.each_with_index do |equation,i|
      result += '&&' + equation.latex + '&\left(' + (i+1).to_s + '\right)&&&&\\\[5pt]' + "\n"
    end
    result = result.chomp("[5pt]\n")
    result += '[15pt]' + "\n"
    result
  end

end
