class Division
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def top
    args[0]
  end

  def top=(value)
    self.args[0] = value
  end

  def bot
    args[1]
  end

  def bot=(value)
    self.args[1] = value
  end

  def ==(exp)
    exp.class == self.class && args == exp.args
  end

end
