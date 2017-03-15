class SingleVariableQuestion
  attr_reader :options, :question

  def initialize(options={})
    @options = init_defaults(options)
    @question = nil
    @solution = nil
  end

  def self.generate_question(options={})
    gen_instance = self.new(options)
    gen_instance.generate_equation
    gen_instance
  end

  def generate_solution
    return @solution unless @solution.nil?
    @solution = @question.solve_one_var_eqn
  end

  def question_latex
    latex_form = question.latex
    LatexUtilities::add_align_env(latex_form)
  end

  def solution_latex
    question_solution = @solution.nil? ? generate_solution : @solution
    latex_form = question_solution.to_latex
    latex_form = LatexUtilities::add_columns(latex_array: latex_form)

    question_latex_form = [latex_form.shift]

    question_latex_form << latex_form.join("\\\\[5pt]\n")
    question_latex_form = question_latex_form.join("\\\\[15pt]\n")
    latex = LatexUtilities::add_align_env(question_latex_form)
    latex + '$ ' + @solution.last.latex + ' $'
  end

  #RECURSION
  def generate_equation
    solution = rand(2..@options[:solution_max])
    left_side = mtp(1, @options[:variable])
    rs = solution

    @options[:number_of_steps].times do
      next_step = _next_step(left_side, rs)
      return generate_equation if GeneralUtilities::includes?(NilClass, object: next_step)
      subed_solution = next_step.subs_terms(@options[:variable], solution)
      rs = subed_solution.evaluate_numeral

      return generate_equation if rs.nil? || rs == 1
      left_side = next_step
    end

    @question = eqn(left_side, rs)
  end

  def _next_step(left_side, rs)
    next_step_ops = _next_step_ops(left_side)
    next_step_dir = next_step_ops == :mtp ? :lft : [:lft, :rgt].sample
    next_step_val = _next_step_val(rs, next_step_ops, next_step_dir)
    args = next_step_dir == :lft ? [next_step_val, left_side] : [left_side, next_step_val]
    if next_step_ops == :sbt
      mtp(-1, add(args))
    else
      Factory.send(next_step_ops, args)
    end
  end

  def _next_step_ops(left_side)
    return [[:add, :sbt], [:mtp, :div]].sample.sample if GeneralUtilities::depth(left_side) == 0
    last_ops = left_side.class
    has_div = GeneralUtilities::includes?(Division, object: left_side)

    if [addition, subtraction].include?(last_ops)
      no_more_div = (!@options[:multiple_division] && has_div)
      return no_more_div ? :mtp : [:div, :mtp].sample
    end
    return [:add, :sbt].sample if [multiplication, division].include?(last_ops)
  end

  def _next_step_val(rs, next_step_ops, next_step_dir)
    return (10..99).to_a.sample if next_step_ops == :add
    return (2..10).to_a.sample if next_step_ops == :mtp
    return (2..rs.abs - 2).to_a.sample if next_step_ops == :sbt && next_step_dir == :rgt
    return (rs + 10..rs.abs + 99).to_a.sample if next_step_ops == :sbt && next_step_dir == :lft
    if next_step_ops == :div && next_step_dir == :lft
      multiples_of_rs = (2..10).collect { |n| n * rs }
      return multiples_of_rs.sample
    end
    if next_step_ops == :div && next_step_dir == :rgt
      divisors_of_rs = (2..rs).select { |n| rs % n == 0 && n != 1 && n < rs }
      return divisors_of_rs.sample
    end
  end

  private

  def init_defaults(options)
    defaults = { variable: 'x',
                 number_of_steps: 2,
                 solution_max: 10,
                 negative_allowed: false,
                 multiple_division: false
               }

    defaults.each do |option, value|
      if !options[option].nil?
        defaults[option] = options[option]
      end
    end
    defaults
  end
end
