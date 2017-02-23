class SineEquationGenerator
  RS_VALUES = [0, frac(1, sqrt(2)), frac(1, 2), frac(sqrt(3), 2)]
  A_VALUES = [frac(1, 3), frac(1, 2)] + (1..6).to_a
  B_VALUES = (-100..100).to_a
  SINGS = ['-@', '+@']

  attr_reader :a, :b, :rs, :variable

  def initialize(variable: 'x')
    @a = { value: nil, sign: nil }
    @b = nil
    @rs = { value: nil, sign: nil }
    @variable = variable
  end

  def generate_equation
    select_variables
    sin_eqn(add(mtp(a, variable), b), rs)
  end

  def select_variables
    p 'Running'
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
    @a[:value] = A_VALUES.sample
    @a[:sign] = rand_sign
  end

  def select_b
   @b = rand_b
  end

  def select_rs
    @rs[:value] = rand_rs
    @rs[:sign] = rand_sign
  end

  def evaluate_numerals
    evals  = evaluate_a_b
    a_var = evals[:a]
    rs_var = evals[:rs]

    ((Math.asin(rs_var) - b) / a_var)
  end

  private

  def is_integer?(num)
    num % 1 == 0
  end

  def rand_sign
    SINGS.sample
  end

  def rand_a
    A_VALUES.sample
  end

  def rand_b
    B_VALUES.sample
  end

  def rand_rs
    RS_VALUES.sample
  end

  def evaluate_a_b
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
