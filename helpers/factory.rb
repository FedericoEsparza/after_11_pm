include ClassName
include Types

module Factory
  def add(*args)
    Addition.new(*args)
  end

  def mtp(*args)
    Multiplication.new(*args)
  end

  def pow(*args)
    Power.new(*args)
  end

  def var(string)
    Variable.new(string)
  end

  def num(n)
    Numeral.new(n)
  end

  def eqn(ls,rs)
    Equation.new(ls,rs)
  end

  def sseqn(eqn_1,eqn_2)
    SimutaneousEqnSubstitution.new(eqn_1,eqn_2)
  end

  def div(*args)
    Division.new(*args)
  end

  def sbt(*args)
    Subtraction.new(*args)
  end

  def sin(*args)
    Sine.new(*args)
  end

  def cos(*args)
    Cosine.new(*args)
  end

  def arcsin(*args)
    ArcSine.new(*args)
  end

  def sin_eqn(ls,rs,options={ans_min:0,ans_max:360})
    SineEquation.new(ls,rs,options)
  end

  def arccos(*args)
    ArcCosine.new(*args)
  end

  def cos_eqn(ls, rs, options: { ans_min: 0, ans_max: 360 })
    CosineEquation.new(ls, rs, options: options)
  end

  def tan(*args)
    Tangent.new(*args)
  end

  def arctan(*args)
    ArcTangent.new(*args)
  end

  def tan_eqn(ls, rs, options: { ans_min: 0, ans_max: 360 } )
    TangentEquation.new(ls, rs, options: options)
  end

  def frac(numerator, denominator, sign: :+)
    Fraction.new(numerator: numerator, denominator: denominator, sign: sign)
  end

  def sqrt(value, sign: :+)
    SquareRoot.new(value: value, sign: sign)
  end

  def quad(quad_term,linear_term,constant_term,variable)
    QuadraticEquation.new(quad_term: quad_term, linear_term: linear_term, constant_term: constant_term, variable: variable)
  end

end
