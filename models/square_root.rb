include Factory

class SquareRoot
  attr_reader :value, :sign

  def initialize(value:, sign: :+)
    @value = value
    @sign = sign.is_a?(String) ? sign : sign.to_s + '@'
  end

  def value=(new_value)
    @value = new_value
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

  def latex
    '\sqrt{' + value.latex + '}'
  end

  private

  def same_class?(object)
    object.is_a?(self.class)
  end
end
