include Factory
require 'prime'
include Latex

class Fraction
  attr_accessor :numerator, :denominator, :sign

  def initialize(numerator:, denominator:, sign: :+)
    @numerator = numerator
    @denominator = denominator
    @sign = sign.is_a?(String) ? sign : sign.to_s + '@'
  end

  def ==(frc)
    return false unless same_class?(frc)

    self.evaluate_numeral == frc.evaluate_numeral
  end

  def abs
    self.sign = '+@'
    self
  end

  def <(numeral)
    return false unless numerical?(numeral)
    if numeral.is_a?(fraction)
      evaluate_numeral < numeral.evaluate_numeral
    else
      evaluate_numeral < numeral
    end
  end

  def >(numeral)
    return false unless numerical?(numeral)
    if numeral.is_a?(fraction)
      evaluate_numeral > numeral.evaluate_numeral
    else
      evaluate_numeral > numeral
    end
  end

  def <=(frc)
    return false unless same_class?(frc)

    self.evaluate_numeral <= frc.evaluate_numeral
  end

  def simplify
      num = numerator
      denom = denominator
    top_primes, top_powers = Prime.prime_division(numerator).transpose
    bot_primes, bot_powers = Prime.prime_division(denominator).transpose

    top_primes = [] if top_primes == nil
    bot_primes = [] if bot_primes == nil

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
    num = num/product
    denom = denom/product
    if denom == 1 || denom == -1
      if sign == "+@"
        num*denom
      else
        -num*denom
      end
    else
      frac(num,denom,sign: sign).check_sign
    end
  end

  def check_sign
    if (numerator<=>0)*(denominator<=>0) < 0
      if sign == "+@"
        if numerator < 0
          frac(-numerator,denominator,sign: :-)
        else
          frac(numerator,-denominator,sign: :-)
        end
      else
        if numerator < 0
          frac(-numerator,denominator)
        else
          frac(numerator,-denominator)
        end
      end
    elsif (numerator<=>0)*(denominator<=>0) == 0
      0
    else
      self
    end

  end

  def negative
    num = -numerator
    frac(num,denominator, sign: sign).check_sign
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

  def base_latex
    if sign == '+@'
      '\frac{' + numerator.base_latex + '}{' + denominator.base_latex + '}'
    else
      '-\frac{' + numerator.base_latex + '}{' + denominator.base_latex + '}'
    end
  end

  private

  def same_class?(object)
    object.is_a?(self.class)
  end
end
