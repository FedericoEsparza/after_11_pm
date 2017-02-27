require './helpers/objectify'

include Objectify

class String
  def latex
    self
  end


  def greater?(exp)
    if exp.is_a?(String)
      self < exp
    elsif exp.is_a?(Numeric)
      true
    else
      self.greater?(exp.args.first)
    end
  end

  def sort_elements
    self
  end

  def shorten
    gsub!('\\left','')
    gsub!('\\right','')
    gsub!('\\displaystyle','')
    self
  end



  def correct_latex?
    objectify(self).latex.shorten == self
  end

end
