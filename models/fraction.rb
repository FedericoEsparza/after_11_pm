require './models/factory'

include Factory

class Fraction
  attr_reader :numerator, :denominator, :sign

  def initialize(numerator:, denominator:, sign: :+)
    @numerator = numerator
    @denominator = denominator
    @sign = sign.to_s + '@'
  end

  def ==(fraction)
    return false unless same_class?(fraction)

    self.evaluate_numeral == fraction.evaluate_numeral
  end

  def <(fraction)
    return false unless same_class?(fraction)

    self.evaluate_numeral < fraction.evaluate_numeral
  end

  def >(fraction)
    return false unless same_class?(fraction)

    self.evaluate_numeral > fraction.evaluate_numeral
  end

  def <=(fraction)
    return false unless same_class?(fraction)

    self.evaluate_numeral <= fraction.evaluate_numeral
  end

  def evaluate_numeral
    top = numerator.respond_to?(:evaluate_numeral) ? numerator.evaluate_numeral : numerator
    bottom = denominator.respond_to?(:evaluate_numeral) ? denominator.evaluate_numeral : denominator

    (top.to_f / bottom).round(5).send(sign)
  end

  private

  def same_class?(object)
    object.is_a?(self.class)
  end
end
