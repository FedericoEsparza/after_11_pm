require './models/factory'

include Factory

class ArcCosine
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def value
    args[0]
  end

  def value=(val)
    self.args[0] = val
  end

  def ==(exp)
    exp.class == self.class && args == exp.args
  end

  def copy
    new_args = args.inject([]) do |r,e|
      if e.is_a?(string) || numerical?(e)
        r << e
      else
        r << e.copy
      end
    end
    arccos(new_args)
  end

  def evaluate_numeral
    rad = Math.acos(value)
    (rad / (Math::PI) * 180).round(5)
  end

  def latex
    value_latex = value.latex
    '\arccos ' + value_latex
  end
end
