class Subtraction
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def copy
    new_args = args.inject([]) do |r,e|
      if e.is_a?(string) || e.is_a?(integer)
        r << e
      else
        r << e.copy
      end
    end
    sbt(new_args)
  end

  def ==(exp)
    exp.class == self.class && args == exp.args
  end

  def minuend
    args[0]
  end

  def minuend=(value)
    self.args[0] = value
  end

  def subend
    args[1]
  end

  def subend=(value)
    self.args[1] = value
  end

  def evaluate_numeral
    minuend - subend
  end

  def reverse_step(rs)
    result = {}
    if args[0].is_a?(integer)
      result[:ls] = args[1]
      result[:rs] = sbt(args[0],rs)
      return result
    end
    if args[1].is_a?(integer)
      result[:ls] = args[0]
      result[:rs] = add(rs,args[1])
      return result
    end
  end

end
