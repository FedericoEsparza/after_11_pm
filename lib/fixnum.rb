require './helpers/latex'

include Latex

class Fixnum

  def base_latex
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

end
