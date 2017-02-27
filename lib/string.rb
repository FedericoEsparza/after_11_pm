class String
  def latex
    self
  end

  def olatex
    gsub!('\\left','')
    gsub!('\\right','')
    gsub!('\\displaystyle','')
    self
  end
end
