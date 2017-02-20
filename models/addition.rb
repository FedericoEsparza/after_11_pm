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

  def copy
    new_args = args.inject([]) do |r,e|
      if e.is_a?(string) || e.is_a?(integer)
        r << e
      else
        r << e.copy
      end
    end
    add(new_args)
  end

  def evaluate
    args.inject(0){ |r, arg|
      arg = arg.is_a?(Numeral) ? arg.value : arg
      r + arg
    }
  end
end
