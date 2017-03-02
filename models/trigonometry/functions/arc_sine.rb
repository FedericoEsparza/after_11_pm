include Factory
include Latex

class ArcSine
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
    arcsin(new_args)
  end

  def evaluate_numeral
    rad = Math.asin(value)
    degree = rad / (Math::PI) * 180
    degree.round
  end

  def base_latex
    value_latex = value.base_latex
    '\arcsin ' + value_latex
  end
end
