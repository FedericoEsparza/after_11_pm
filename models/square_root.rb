include Factory
include Latex

class SquareRoot
  attr_reader :value, :sign

  def initialize(value:, sign: :+)
    @value = value
    @sign = sign.is_a?(String) ? sign : sign.to_s + '@'
  end

  def value=(new_value)
    @value = new_value
  end

  def sign=(new_sign)
    @sign = new_sign
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
    # if value.is_a?(string) || value.is_a?(integer)
    #   val = value
    # else
    #   val = value.copy
    # end
    # sqrt(value: val, sign: sign)
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
