class Power
  attr_accessor :args

  def initialize(*args)
    @args = args
  end

  def ==(exp)
    args = exp.args
  end

  def evaluate
    args[0] ** args[1]
  end
end
