include Factory
include Latex

class SquareRoot
  # attr_reader :value, :sign
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
    if @args[1].nil?
      @args[1]='+@'
    else
      @args[1] = @args[1].is_a?(String) ? sign : sign.to_s + '@'
    end
  end

  def value
    args[0]
  end

  def sign
    args[1]
  end

  def value=(value)
    self.args[0] = value
  end

  def sign=(sign)
    @args[1] = sign
  end

  def ==(sqr)
    return false unless same_class?(sqr)

    self.evaluate_numeral == sqr.evaluate_numeral
  end

  def evaluate_numeral
    val = value.respond_to?(:evaluate_numeral) ? value.evaluate_numeral : value
    Math.sqrt(val).send(sign)
  end

  def copy
    DeepClone.clone self
  end

  def base_latex
    '\sqrt{' + value.base_latex + '}'
  end

  alias_method :~, :==

  private

  def same_class?(object)
    object.is_a?(self.class)
  end
end
