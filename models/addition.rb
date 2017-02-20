class Addition
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def ==(exp)
    exp.class == self.class && args == exp.args
  end

  def evaluate
    args.inject(0){ |r, arg|
      arg = arg.is_a?(Numeral) ? arg.value : arg
      r + arg
    }
  end
end
