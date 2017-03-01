class Fixnum
require "prime"

  def latex
    self.to_s
  end


  def greater? (exp)
    if exp.is_a?(Fixnum)
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

end
