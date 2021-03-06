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

    # self.evaluate_numeral == frc.evaluate_numeral

    (numerator == frc.numerator && denominator == frc.denominator) ||
    (numerator.is_a?(Numeric) && denominator.is_a?(Numeric) && self.evaluate_numeral == frc.evaluate_numeral)
  end

  def abs
    self.sign = '+@'
    self
  end

  def *(numeral)
    self.evaluate_numeral * numeral
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

  def *(exp)
    new_frac = frac(mtp(numerator,exp).evaluate_numeral,denominator)
  end

  def mult(exp)
    new_frac = frac(mtp(numerator,exp).evaluate_numeral,denominator)
  end

  def greater?(exp)
    if exp.is_a?(Fixnum) || exp.is_a?(fraction)
      self > exp
    else
      false
    end
  end

  def contains?(subject)
    false
  end

  def <=(frc)
    return false unless same_class?(frc)

    self.evaluate_numeral <= frc.evaluate_numeral
  end

  def sort_elements
    self
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

  def split_num
    if numerator.is_a?(Addition)
      new_args = []
      new_sign = sign
      numerator.args.each do |num|
        new_args << frac(num,denominator,sign: sign)
      end
      return add(new_args)
    else
      self
    end
  end

#curently primitive
  def elim_common_factors
    if numerator.is_a?(multiplication)
      num_factors = numerator.args
      num = numerator
    else
      num_factors = [numerator]
      num = mtp(numerator)
    end

    if denominator.is_a?(multiplication)
      denom_factors = denominator.args
      denom = denominator
    else
      denom_factors = [denominator]
      denom = mtp(denominator)
    end

    i = 0
    while i < denom_factors.length
      factor = denom_factors[i]
      if num_factors.count(factor) > 0
        denom_factors.delete_at(denom_factors.rindex(factor))
        num_factors.delete_at(num_factors.rindex(factor))
      else
        i += 1
      end
    end

    if denom_factors.length == 0
      denom = 1
    elsif denom_factors.length == 1
      denom = denom_factors.first
    else
      denom = mtp(denom_factors)
    end

    if num_factors.length == 0
      num = 1
    elsif num_factors.length == 1
      num = num_factors.first
    else
      num = mtp(num_factors)
    end

    if denom == 1
      if sign == "+@"
        num
      else
        mtp(-1,num)
      end
    else
      frac(num,denom, sign: sign)
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

  def find_denoms
    return [denominator]
  end

  def base_latex
    if sign == '+@'
      '\frac{' + numerator.base_latex + '}{' + denominator.base_latex + '}'
    else
      '-\frac{' + numerator.base_latex + '}{' + denominator.base_latex + '}'
    end
  end

  alias_method :~, :==

  private

  def same_class?(object)
    object.is_a?(self.class)
  end
end
