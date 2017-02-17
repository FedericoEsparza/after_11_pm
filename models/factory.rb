module Factory
  def add(*args)
    Addition.new(*args)
  end

  def mtp(*args)
    Multiplication.new(*args)
  end

  def pow(base,index)
    Power.new(base,index)
  end

  def eqn(ls,rs)
    Equation.new(ls,rs)
  end

  def div(top,bot)
    Division.new(top,bot)
  end

  def sbt(minuend,subend)
    Subtraction.new(minuend,subend)
  end
end
