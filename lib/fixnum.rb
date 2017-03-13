require './helpers/latex'
require './helpers/general_utilities'

include Latex
include GeneralUtilities

class Fixnum
  require "prime"

  def base_latex
    self.to_s
  end

  def copy
    self
  end

  def base
    self
  end

  def greater? (exp)
    if exp.is_a?(Fixnum) || exp.is_a?(fraction)
      self > exp
    else
      false
    end
  end

  def sort_elements
    self
  end

  def expand
    [self]
  end

  def flatit
    self
  end

  # def mult(fract)
  #   if fract.is_a?(fraction)
  #     frac(mtp(fract.numerator,self).evaluate_numeral,fract.denominator)
  #   else
  #     self*fract
  #   end
  # end
  #
  # def plus(fract)
  #   if fract.is_a?(fraction)
  #     frac(add(fract.numerator,self).evaluate_numeral,fract.denominator)
  #   else
  #     self+fract
  #   end
  # end


  # def flatit
  #   self
  # end

  def prime_factorisation
    n = self
    Prime.prime_division(n).flat_map { |factor, power| [factor] * power }
  end

  def factorisation
    n = self
    prime_factors, powers = Prime.prime_division(n).transpose
    exponents = powers.map{|i| (0..i).to_a}

    factors = exponents.shift.product(*exponents).map do |powers|
      prime_factors.zip(powers).map{|prime, power| prime ** power}.inject(:*)
    end
    factors.sort.map{|div| [div, n / div]}
  end

  def find_vars
    []
  end

  alias_method :~, :==
end
