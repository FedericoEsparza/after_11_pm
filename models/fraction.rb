include Factory
require 'prime'

class Fraction
  attr_accessor :numerator, :denominator, :sign

  def initialize(numerator:, denominator:, sign: :+)
    @numerator = numerator
    @denominator = denominator
    @sign = sign.is_a?(String) ? sign : sign.to_s + '@'
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

  def simplify
    top_prime_factors = prime_factorization(numerator)
    bot_prime_factors = prime_factorization(denominator)
    common_factors = top_prime_factors & bot_prime_factors
    product = common_factors.evaluate_product
    self.numerator = numerator/product
    self.denominator = denominator/product
    self
  end

  def prime_factorization(n)
    Prime.prime_division(n).flat_map { |factor, power| [factor] * power }
  end


  def copy
    DeepClone.clone self
    # if numerator.is_a?(string) || numerator.is_a?(integer)
    #   top = numerator
    # else
    #   top = numerator.copy
    # end
    # if denominator.is_a?(string) || denominator.is_a?(integer)
    #   bottom = denominator
    # else
    #   bottom = denominator.copy
    # end
    # frac(numerator: top, denominator: bottom, sign: sign)
  end

  def evaluate_numeral
    top = numerator.respond_to?(:evaluate_numeral) ? numerator.evaluate_numeral : numerator
    bottom = denominator.respond_to?(:evaluate_numeral) ? denominator.evaluate_numeral : denominator

    (top.to_f / bottom).send(sign)
  end

  def latex
    '\frac{' + numerator.latex + '}{' + denominator.latex + '}'
  end

  private

  def same_class?(object)
    object.is_a?(self.class)
  end
end
