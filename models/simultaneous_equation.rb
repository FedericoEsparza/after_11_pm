class SimultaneousEquation
  include LatexUtilities

  attr_reader :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def eq_1
    args[0]
  end

  def eq_2
    args[1]
  end

  def eq_3(val = nil)
    @eq_3 = val || @eq_3
  end

  def eq_4(val = nil)
    @eq_4 = val || @eq_4
  end

  def copy
    DeepClone.clone self
  end

  def generate_solution
    equation_1_coefs = extract_coefficient(eq_1)
    equation_2_coefs = extract_coefficient(eq_2)
    solutions = {}
    steps = []

    mtp_eqn = []
    mtped_eqn = []
    determine_multiplier.each do |k, v|
      new_eqn = eqn(mtp(v.to_i, self.send(k).ls), mtp(v.to_i, self.send(k).rs))

      k == :eq_1 ? eq_3(new_eqn) : eq_4(new_eqn)
      mtp_eqn << new_eqn

      equation_1_coefs.update(equation_1_coefs) { |_var, coef| coef * v } if k == :eq_1
      equation_2_coefs.update(equation_2_coefs) { |_var, coef| coef * v } if k == :eq_2
    end

    expand_equations

    mtped_eqn << [eq_3, eq_4].compact

    steps << mtp_eqn
    steps << mtped_eqn

    negative = negative?(equation_1_coefs, equation_2_coefs)

    steps << add_equations(negative: negative)
    steps << eqn(steps.last.ls.expand.last.simplify_add_m_forms, steps.last.rs.expand.last.evaluate)
    steps << steps.last.flatten.solve_one_var_eqn

    solutions = solutions.merge(extract_var(steps.last.last))

    steps << sub_in(steps.last.last)
    steps << steps.last.flatten.expand.last.flatten
    steps << steps.last.solve_one_var_eqn

    solutions = solutions.merge(extract_var(steps.last.last))

    { steps: steps, negative: negative, solutions: solutions }
  end

  def solution_latex
    solution = self.generate_solution
    solutions = solution[:solutions]
    response = []
    latex_solution = solution[:steps].to_latex

    eq_1_solution_latex = add_columns(num_of_column: 3, on_right: 2, latex_array: latex_solution[4])
    eq_2_solution_latex = add_columns(num_of_column: 3, on_right: 2, latex_array: latex_solution[7])

    eqs_latex = add_columns(num_of_column: 3, on_right: 2, skip_first: true, latex_array: eqs_to_latex)
    mtped_eqs_latex = add_columns(num_of_column: 2, latex_array: mtped_eqs_to_latex)
    eq_addition = add_columns(num_of_column: 2, latex_array: eq_addition_latex(latex_solution[2], solution[:negative]))
    sub_in_eqs_latex = add_columns(num_of_column: 2, latex_array: sub_in_latex(latex_solution[5], solution[:steps][4].last))

    response << eqs_latex
    response << mtped_eqs_latex unless mtped_eqs_latex.empty?
    response << eq_1_solution_latex.unshift(eq_addition)
    response << eq_2_solution_latex.unshift(sub_in_eqs_latex)
    response = response.map do |element|
      element.is_a?(Array) ? element.join("\\\\\n") : element + "\\\\\n"
    end

    add_align_env(response.join("\\\\[15pt]\n")) + eq_solutions(solutions)
  end

  def eq_solutions(solution_hash)
    solutions = []
    solution_hash.each do |var, val|
      solutions << var.to_s + '=' + val.to_s
    end
    '$ ' + solutions.join(', ') + ' $'
  end

  def eq_addition_latex(latex, negative)
    index = nil
    operation = negative ? '-' : '+'
    if !eq_3.nil? && !eq_4.nil?
      index = "&(3)#{operation}(4)&"
    elsif !eq_3.nil? || !eq_4.nil?
      index = "&(1)#{operation}(3)&"
    else
      index = "&(1)#{operation}(2)&"
    end
    index + latex
  end

  def eqs_to_latex
    response = []
    response << add_eq_index(latex: eq_1.latex, index: 1, side: :right)
    response << add_eq_index(latex: eq_2.latex, index: 2, side: :right)
    response
  end

  def mtped_eqs_to_latex
    instruction = determine_multiplier
    keys = instruction.keys
    eq_index = 2
    response = []
    response << "&(#{1})\\times#{instruction[:eq_1].to_i}&" + add_eq_index(latex: eq_3.latex, index: (eq_index += 1), side: :right) if keys.include?(:eq_1) && instruction[:eq_1] != 1
    response << "&(#{2})\\times#{instruction[:eq_2].to_i}&" + add_eq_index(latex: eq_4.latex, index: (eq_index += 1), side: :right) if keys.include?(:eq_2) && instruction[:eq_2] != 1
    response
  end

  def sub_in_latex(latex, var_ans)
    var = var_ans.fetch(object: :string)
    sub_text = "&\\text{Sub}\\hspace{5pt} #{var}\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&"
    sub_text + latex
  end

  def sub_in(var_ans)
    var = extract_var(var_ans).keys.first
    value = extract_var(var_ans).values.first
    eq_1_copy = eq_1.copy
    eq_1_copy.subs_terms(var,value)
  end

  def extract_var(var_ans)
    { var_ans.fetch(object: :string) => var_ans.fetch(object: :numeric) }
  end

  def expand_equations
    if !eq_3.nil?
      new_eqn = eqn(eq_3.ls.expand.last, eq_3.rs.evaluate_numeral)
      eq_3(new_eqn)
    end

    if !eq_4.nil?
      new_eqn = eqn(eq_4.ls.expand.last, eq_4.rs.evaluate_numeral)
      eq_4(new_eqn)
    end
  end

  def add_equations(negative:)
    coef = negative ? -1 : 1

    if !eq_3.nil? && !eq_4.nil?
      eqn(add(eq_3.ls, mtp(coef, eq_4.ls)), add(eq_3.rs, mtp(coef, eq_4.rs)))
    elsif !eq_3.nil?
      eqn(add(eq_2.ls, mtp(coef, eq_3.ls)), add(eq_2.rs, mtp(coef, eq_3.rs)))
    elsif !eq_4.nil?
      eqn(add(eq_1.ls, mtp(coef, eq_4.ls)), add(eq_1.rs, mtp(coef, eq_4.rs)))
    else
      eqn(add(eq_1.ls, mtp(coef, eq_2.ls)), add(eq_1.rs, mtp(coef, eq_2.rs)))
    end
  end

  def negative?(equation_1_coefs, equation_2_coefs)
    equation_1_coefs.each do |var, coef|
      next if equation_2_coefs[var].nil?

      if equation_2_coefs[var].abs == coef.abs
        if coef.negative? && equation_2_coefs[var].negative?
          return true
        end

        if coef.positive? && equation_2_coefs[var].positive?
          return true
        end
        return false
      end
    end
  end

  def determine_multiplier
    equation_1_coefs = extract_coefficient(eq_1)
    equation_2_coefs = extract_coefficient(eq_2)
    keys = equation_1_coefs.keys
    response = {}

    equation_1_coefs.each do |var, coef|
      next if equation_2_coefs[var].nil?
      factor = coef.to_f / equation_2_coefs[var]
      factor_2 = equation_2_coefs[var] / coef.to_f

      response[:eq_2] = factor.abs if factor % 1 == 0 && factor != 0
      response[:eq_1] = factor_2.abs if factor_2 % 1 == 0 && (factor % 1 != 0 || factor == 0)
    end

    if response.empty?
      coef_lcm = []

      equation_1_coefs.each do |var, coef|
        next if equation_2_coefs[var].nil?
        coef_lcm << coef.abs.lcm(equation_2_coefs[var].abs)
      end

      if coef_lcm[0] > coef_lcm[1]
        response[:eq_1] = coef_lcm[1] / equation_1_coefs[keys.last].abs
        response[:eq_2] = coef_lcm[1] / equation_2_coefs[keys.last].abs
      else
        response[:eq_1] = coef_lcm[0] / equation_1_coefs[keys.first].abs
        response[:eq_2] = coef_lcm[0] / equation_2_coefs[keys.first].abs
      end
    end

    response
  end

  def extract_coefficient(equation)
    extracted_obj = []
    response = {}
    eqn_ls = equation.ls

    extracted_obj << eqn_ls.fetch_all(object: :multiplication) unless eqn_ls.is_a?(String)
    extracted_obj << equation.ls.fetch_all(object: :string) unless eqn_ls.is_a?(String)

    extracted_obj.flatten.each do |obj|
      if obj.is_a?(Multiplication)
        response[obj.fetch(object: :string)] = obj.fetch(object: :numeric) if obj.includes?(String) && obj.includes?(Numeric)
        response[obj.fetch(object: :string)] = 1 if obj.includes?(String) && !obj.includes?(Numeric)
      end

      if obj.is_a?(String)
        response[obj] = 1
      end
    end

    response
  end
end
