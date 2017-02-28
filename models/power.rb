include Factory

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

  def latex
    base_latex = base.latex
    unless elementary?(base)
      base_latex = brackets(base_latex)
    end
    index_latex = index.latex
    if elementary?(index) == false || index.to_s.length > 1
      index_latex = '{' + index_latex +  '}'
    end
    # unless elementary?(index)
    #   index_latex = '{' + index_latex +  '}'
    # end
    base_latex + '^' + index_latex
  end
end
