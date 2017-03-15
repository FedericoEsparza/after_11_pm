class SimultaneousEquationQuestion
  attr_reader :options, :question

  def initialize(options = {})
    @options = init_default(options)
    @question = nil
    @solution = nil
  end

  def self.generate_question(options={})
    gen_instance = self.new(options)
    gen_instance.generate_equation
    gen_instance
  end


  def generate_equation
    response = []
    solutions = select_solutions
    var_1 = @options[:vars][0]
    var_2 = @options[:vars][1]
    a = @options[:coef_range_1].sample
    c = @options[:coef_range_2].sample

    while a.abs == c.abs
      c = @options[:coef_range_2].sample
    end

    b = possible_set(a).sample
    d = possible_set(c, set_num: 2).sample

    eq_1_solution = (a * solutions[0]) + (b * solutions[1])
    eq_2_solution = (c * solutions[0]) + (d * solutions[1])

    response << eqn(add(mtp(a, var_1), mtp(b, var_2)), eq_1_solution)
    response << eqn(add(mtp(c, var_1), mtp(d, var_2)), eq_2_solution)
    @question = response
  end

  def generate_solution(method: :elimination)
    sim_eqn = method == :elimination ? seqn(@question) : sseqn(@question)
    @solution = sim_eqn.generate_solution
  end

  def question_latex
    latex = @question.map { |q| q.latex }.join("\\\\\n")
    LatexUtilities::add_align_env(latex)
  end

  def solution_latex(method: :elimination)
    sim_eqn = method == :elimination ? seqn(@question) : sseqn(@question)
    sim_eqn.solution_latex
  end

  private

  def possible_set(coef, set_num: 1)
    set = 'coef_range_' + set_num.to_s
    numeric_set = @options[set.to_sym].select { |e| coef.gcd(e) == 1 }
    numeric_set.map { |e| coef.negative? ? e.abs : e }
  end

  def select_solutions
    solutions = @options[:solution_set].sample(2)
    solutions.map { |s| @options[:negative_solution_allowed] ? s : s.abs }
  end

  def init_default(options)
    defaults = { solution_set: remove_zero((-4..4).to_a),
                 coef_range_1: remove_zero((-9..9).to_a),
                 coef_range_2: remove_zero((-9..9).to_a),
                 negative_solution_allowed: false,
                 vars: %w(x y)
               }

    defaults.each do |option, value|
      if options[option].nil?
        value
      else
        defaults[option] = options[option].is_a?(Array) ? remove_zero(options[option]) : options[option]
      end
    end
    defaults
  end

  def remove_zero(array)
    array.delete(0)
    array
  end
end
