class SineEquationGenerator
  RS_VALUES = [frac(1, sqrt(2)), frac(1, 2), frac(sqrt(3), 2), 0]
  A_VALUES = [0, frac(1, 3), frac(1, 2)] + (1..6).to_a
  B_VALUES = (-100..100).to_a
  SINGS = ['-@', '+@']

  attr_reader :a, :b, :rs, :variable, :limits

  def initialize(variable: 'x', limits: [0, 360], a_values: A_VALUES, b_values: B_VALUES)
    @a = { value: nil, sign: nil }
    @b = nil
    @rs = { value: nil, sign: nil }
    @variable = variable
    @limits = limits
    @a_values = a_values
    @b_values = b_values
  end

  def generate_equation
    select_variables
    compose_equation
  end

  def compose_equation
    evals  = evaluate_a_rs
    ls = nil

    rs_var =  if rs[:value].is_a?(Fraction)
                rs[:value].sign = rs[:sign]
                rs[:value]
              else
                rs[:value].send(rs[:sign])
              end

    if a[:value].is_a?(Fraction)
      ax = div(variable, a[:value].denominator)
    else
      ax = variable
      ax = mtp(a[:value], variable) unless a[:value] == 0
    end

    if a[:sign] == '-@'
      ls = ax
      ls = sbt(b, ax) unless b == 0
    else
      ls = ax
      ls = add(ax, b) unless b == 0
      ls = sbt(ax, b.abs) if b.negative? && b != 0
    end

    sin_eqn(ls, rs_var, ans_min: limits[0], ans_max: limits[1])
  end

  def select_variables
    select_a
    select_b
    select_rs
    if is_integer?(evaluate_numerals)
      evaluate_numerals.round
    else
      select_variables
    end
  end

  def select_a
    @a[:value] = rand_a
    @a[:sign] = rand_sign
  end

  def select_b
    @b = (@a[:sign] == '-@') ? rand_b.abs : rand_b
  end

  def select_rs
    @rs[:value] = rand_rs
    @rs[:sign] = rand_sign
  end

  def evaluate_numerals
    evals  = evaluate_a_rs
    a_var = evals[:a]
    rs_var = evals[:rs]
    return 0.75 if a_var == 0 || b == 0
    p a_var
    p b
    p Math.asin(rs_var).degrees.round
    ((Math.asin(rs_var).degrees.round - b.to_f) / a_var)
  end

  private

  def is_integer?(num)
    num % 1 == 0
  end

  def rand_sign
    SINGS.sample
  end

  def rand_a
    @a_values.sample
  end

  def rand_b
    @b_values.sample
  end

  def rand_rs
    index = (0...RS_VALUES.length).to_a.sample
    RS_VALUES[index]
  end

  def evaluate_a_rs
    a_var = if a[:value].respond_to?(:evaluate_numeral)
              a[:value].evaluate_numeral.send(a[:sign])
            else
              a[:value].send(a[:sign])
            end

    rs_var = if rs[:value].respond_to?(:evaluate_numeral)
               rs[:value].evaluate_numeral.send(rs[:sign])
             else
               rs[:value].send(rs[:sign])
             end

    { a: a_var, rs: rs_var }
  end
end
