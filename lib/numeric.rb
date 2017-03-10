# require 'deep_clone'
# require './models/class_names'
# require './lib/array'
# require './lib/string'
# require './models/multiplication'
# require './models/power'
# require './models/addition'
# require './models/variables'
# require './models/numerals'
# require './models/factory'

class Numeric

  def greater? (exp)
    if exp.is_a?(Numeric) || exp.is_a?(fraction)
      self > exp
    else
      false
    end
  end

  def contains?(subject)
    false
  end

  def sort_elements
    self
  end

  def prime_factorization(n)
    Prime.prime_division(n).flat_map { |factor, power| [factor] * power }
  end

  def radiance
    self * Math::PI / 180
  end

  def degrees
    self * 180 / Math::PI
  end
  # def <(exp)
  #   if exp.is_a?(String)
  #     self > exp
  #   else
  #     self < exp.args.first
  #   end
  # end

  def find_denoms
    []
  end

  def find_vars
    []
  end

  def subs_terms(old_var,new_var)
    if self == old_var
      return new_var
    else
      self
    end
  end


end
