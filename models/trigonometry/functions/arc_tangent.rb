include Factory
include Latex

class ArcTangent
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
    DeepClone.clone self
    # new_args = args.inject([]) do |r,e|
    #   if e.is_a?(string) || numerical?(e)
    #     r << e
    #   else
    #     r << e.copy
    #   end
    # end
    # arctan(new_args)
  end

  def evaluate_numeral
    val = value.respond_to?(:evaluate_numeral) ? value.evaluate_numeral : value
    rad = Math.atan(val)
    (rad / (Math::PI) * 180).round
  end

  def base_latex
    value_latex = value.base_latex
    '\arctan ' + value_latex
  end

  alias_method :~, :==
end
