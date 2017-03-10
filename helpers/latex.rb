module Latex
  def latex
    conventionalised = conventionalise(self)
    conventionalised.base_latex
  end
end
