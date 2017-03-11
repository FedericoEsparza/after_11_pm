include Factory
include Latex

class Power
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def ==(exp)
    exp.class == self.class && base == exp.base && index == exp.index
  end

  def base
    args[0]
  end

  def base=(value)
    self.args[0] = value
  end

  def index
    args[1]
  end

  def index=(value)
    self.args[1] = value
  end

  def copy
    if base.is_a?(string) || base.is_a?(integer)
      copied_base = base
    else
      copied_base = base.copy
    end
    if index.is_a?(string) || index.is_a?(integer)
      copied_index = index
    else
      copied_index = index.copy
    end
    pow(copied_base,copied_index)
  end

  def evaluate
    base ** index
  end

  def base_latex
    latex_of_base = base.base_latex
    unless elementary?(base)
      latex_of_base = brackets(latex_of_base)
    end
    index_latex = index.base_latex
    if elementary?(index) == false || index.to_s.length > 1
      index_latex = '{' + index_latex +  '}'
    end
    # unless elementary?(index)
    #   index_latex = '{' + index_latex +  '}'
    # end
    latex_of_base + '^' + index_latex
  end

  def sort_elements
    array = self.copy
    pow(array.base.sort_elements,array.index.sort_elements)
  end

  def reverse_subject_step(subject,rs)
    result = {}

    if base.contains?(subject)
      result[:ls] = base
      result[:rs] = pow(rs,div(1,index))
      return result
    elsif index.contains?(subject)
      ## wait for logs
    end
  end

  def subs_terms(old_var,new_var)
    if self == old_var
      return new_var
    else
      pow(base.subs_terms(old_var,new_var),index.subs_terms(old_var,new_var))
    end
  end

  def contains?(subject)
    result = false
    if self == subject
      result = true
    elsif base.contains?(subject)
      result = true
    end

    result
  end

  def greater?(exp)
    if exp.class == self.class
      (self.base.greater?(exp.base)) || (self.base == exp.base && self.index.greater?(exp.index))
    elsif exp.is_a?(Numeric) || exp.is_a?(String)
      (self.base.greater?(exp)) || self.base == exp
    else
      self.greater?(exp.args.first)
    end
  end

  def expand
    if index.is_a?(integer) && index >= 0 && !(base.is_a?(string))
      if index == 0
        return 1
      else
        i = index
        factors = []
        while i > 0
          factors << base
          i = i-1
        end
        mtp(factors).expand
      end
    else
      [self]
    end
  end

  def find_denoms
    denoms = base.find_denoms
    if denoms.length > 0
      return pow(denoms, index)
    else
      return []
    end
  end

  def find_vars
    vars = []
    args.each{|a| vars += a.find_vars}
    vars
  end

  alias_method :~, :==
end
