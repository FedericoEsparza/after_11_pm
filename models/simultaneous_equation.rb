class SimultaneousEquation
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

  def solve
    determine_multiplier
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
        response[:eq_1] = coef_lcm[1] / equation_1_coefs[keys.last]
        response[:eq_2] = coef_lcm[1] / equation_2_coefs[keys.last]
      else
        response[:eq_1] = coef_lcm[0] / equation_1_coefs[keys.first]
        response[:eq_2] = coef_lcm[0] / equation_2_coefs[keys.first]
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
