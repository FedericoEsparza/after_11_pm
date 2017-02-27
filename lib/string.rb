# require './helpers/objectify'

include Objectify

class String
  def latex
    self
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
