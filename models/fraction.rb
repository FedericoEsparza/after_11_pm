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
    top_primes, top_powers = Prime.prime_division(numerator).transpose
    bot_primes, bot_powers = Prime.prime_division(denominator).transpose

    # top_primes = top_primes.map{|a| a**top_powers[top_primes.rindex(a)]}
    # bot_primes = bot_primes.map{|a| a**bot_powers[bot_primes.rindex(a)]}
    common_factors = top_primes & bot_primes
    common_powers = []
    common_factors.each do |factor|
      common_powers << [
        top_powers[top_primes.rindex(factor)],
        bot_powers[bot_primes.rindex(factor)]
      ].min
    end
    common_factors = common_factors.each_with_index.map{|a,i| a**common_powers[i]}
    product = common_factors.evaluate_product
    self.numerator = numerator/product
    self.denominator = denominator/product
    if denominator == 1
      if sign == "+@"
        numerator
      else
        -numerator
      end
    else
      self
    end
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
