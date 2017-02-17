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

  def var(string)
    Variable.new(string)
  end

  def num(n)
    Numeral.new(n)
  end
end
