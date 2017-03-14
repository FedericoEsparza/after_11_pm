include Factory
include Latex

class BaseTrigonometry

  def ==(exp)
    exp.class == self.class && args == exp.args
  end

  def copy
    DeepClone.clone self
  end

  def sort_elements
    array = self.copy
    self.new(array.angle.sort_elements)
  end

  def contains?(subject)
    (self == subject) || angle.contains?(subject)
  end

  def subs_terms(old_var, new_var)
    if self == old_var
      return new_var
    else
      self.new(angle.subs_terms(old_var,new_var))
    end
  end

  def find_denoms
    []
  end

  def find_vars
    vars = []
    args.each{|a| vars += a.find_vars}
    vars
  end

  def expand
    steps = angle.expand
    steps.map{|a| cos(a)}
  end

  def flatit
    self.new(angle.flatit)
  end

  def greater?(exp)
    if self.class == exp.class
      angle.greater?(exp.angle)
    else
      angle.greater?(exp)
    end
  end

  alias_method :~, :==
end
