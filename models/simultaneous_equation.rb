class SimultaneousEquation
  include LatexUtilities

  attr_reader :args

  def initialize(*args)
    @args = args
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

  def solve
    equation_1_coefs = extract_coefficient(eq_1)
    equation_2_coefs = extract_coefficient(eq_2)
    instruction = determine_multiplier
    steps = []

    mtp_eqn = []
    mtped_eqn = []
    determine_multiplier.each do |k, v|
      new_eqn = eqn(mtp(v.to_i, self.send(k).ls), mtp(v.to_i, self.send(k).rs))

      k == :eq_1 ? eq_3(new_eqn) : eq_4(new_eqn)
      mtp_eqn << new_eqn

      equation_1_coefs.update(equation_1_coefs) { |var, coef| coef * v } if k == :eq_1
      equation_2_coefs.update(equation_2_coefs) { |var, coef| coef * v } if k == :eq_2
    end

    expand_equations

    mtped_eqn << [eq_3, eq_4].compact

    steps << mtp_eqn
    steps << mtped_eqn

    steps << add_equations(negative: negative?(equation_1_coefs, equation_2_coefs))
    steps << eqn(steps.last.ls.expand.last.simplify_add_m_forms, steps.last.rs.expand.last.evaluate)
    # steps << steps.last.solve_one_var_eqn

    steps
    # [equation_1_coefs, equation_2_coefs]
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

    if !eq_3.nil? && !eq_3.nil?
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
        negative = coef.negative? && equation_2_coefs[var].negative?
        add_equations(negative: negative)
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

    extracted_obj << equation.ls.fetch_all(object: :multiplication)
    extracted_obj << equation.ls.fetch_all(object: :string)

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

  # RECURSION
  def fetch(object:)
    object_class = Kernel.const_get(object.to_s.capitalize)
    args.each do |arg|
      if arg.is_a?(Power)
        return arg.args.each { |e|
          return e if e.is_a?(object_class)
        }
      elsif arg.is_a?(self.class)
        return arg.fetch(object: object)
      else
        return arg if arg.is_a?(object_class)
      end
    end
  end
  # RECURSION
  def includes?(object_class)
    args.any? do |arg|
      if arg.is_a?(Power)
        arg.args.any? { |e| e.is_a?(object_class) }
      elsif arg.is_a?(self.class)
        arg.includes?(object_class)
      else
        arg.is_a?(object_class)
      end
    end
  end

end
