require './helpers/latex'

include Latex

class Float
  def base_latex
    self.to_s
  end
end
