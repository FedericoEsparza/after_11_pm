include Factory
include Latex

class Differentiation
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def func
    args[0]
  end

  def func=(value)
    self.args[0] = value
  end

  def var
    args[1]
  end

  def var=(value)
    self.args[1] = value
  end

  def evaluate
    # add code here
    return ['array of steps for differentiation']
  end


end
