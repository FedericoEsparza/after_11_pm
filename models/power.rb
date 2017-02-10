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
    args == exp.args
  end

  def evaluate
    args[0] ** args[1]
  end
end
