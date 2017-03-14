require './helpers/latex'

include Latex

class NilClass
  def base_latex
    ''
  end

  def copy
    nil
  end
end
