require './models/types'
require './models/class_names'
require './lib/array'
require './models/addition'
require './models/subtraction'
require './models/division'
require './models/multiplication'
require './models/sine'
require './models/arc_sine'
require './models/numerals'
require './models/variables'

include ClassName
include Types

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

  def eqn(ls,rs)
    Equation.new(ls,rs)
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

  def arcsin(*args)
    ArcSine.new(*args)
  end

  def sin_eqn(ls,rs,options={ans_min:0,ans_max:360})
    SineEquation.new(ls,rs,options)
  end
end
