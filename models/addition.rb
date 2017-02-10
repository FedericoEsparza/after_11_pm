class Addition
  attr_accessor :args

  def initialize(*args)
    @args = args
  end

  def ==(exp)
    args = exp.args
  end

  def evaluate
    args.inject(0){|r,e| r + e}
  end
end
