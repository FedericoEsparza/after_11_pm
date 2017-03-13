class SingleVariableQuestion
  attr_reader :options

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

  def generate_equation
    solution = rand(2..@options[:solution_max])
    left_side = [Step.new(nil, @options[:variable])]
    current_value = solution
    @options[:number_of_steps].times do
      next_step = _next_step(left_side, current_value)
      current_value = evaluate([Step.new(nil, current_value), next_step])
      if current_value.nil? || current_value == 1
        return generate_question
      end
      left_side << next_step
    end
    left_expression = Expression.new(left_side)
    right_expression = Expression.new([Step.new(nil, current_value)])
    equation_solution = { @options[:variable] => solution }
    LinearEquation.new(left_expression, right_expression, equation_solution)
  end

  #RECURSION
  def compose_equation
    solution = rand(2..@options[:solution_max])
    left_side = mtp(1, @options[:variable])
    rs = solution

    @options[:number_of_steps].times do
      next_step = _next_step(left_side, rs)
      rs = next_step.evaluate_numeral

      return compose_equation if rs.nil? || rs == 1
      left_side = next_step
    end

    @question = eqn(left_side, rs)
  end

  def self._next_step(left_side, rs)
    next_step_ops = _next_step_ops(left_side)
    next_step_dir = next_step_ops == :mtp ? :lft : [:lft, :rgt].sample
    next_step_val = _next_step_val(rs, next_step_ops, next_step_dir)
    Step.new(next_step_ops, next_step_val, next_step_dir)
  end

  def self._next_step_ops(left_side)
    return [[:add, :sbt], [:mtp, :div]].sample.sample if left_side.length == 1
    last_ops = left_side.last.ops
    has_div = false
    left_side.each do |step|
      has_div = true if step.ops == :div
    end
    if [:add, :sbt].include?(last_ops)
      no_more_div = (!@options[:multiple_division] && has_div)
      return no_more_div ? :mtp : [:mtp, :div].sample
    end
    return [:add, :sbt].sample if [:mtp, :div].include?(last_ops)
  end

  def self._next_step_val(current_value, next_step_ops, next_step_dir)
    return (10..99).to_a.sample if next_step_ops == :add
    return (2..10).to_a.sample if next_step_ops == :mtp
    return (2..current_value - 2).to_a.sample if next_step_ops == :sbt &&
                                                 next_step_dir == :rgt
    return (current_value + 10..current_value + 99).to_a.sample if
      next_step_ops == :sbt && next_step_dir == :lft
    if next_step_ops == :div && next_step_dir == :lft
      multiples_of_current_value = (2..10).collect { |n| n * current_value }
      return multiples_of_current_value.sample
    end
    if next_step_ops == :div && next_step_dir == :rgt
      divisors_of_current_value = (1..current_value).select { |n| current_value % n == 0 && n != 1 && n < current_value }
      return divisors_of_current_value.sample
    end
  end

  def generate_solution

  end

  def question_latex

  end

  def solution_latex

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
