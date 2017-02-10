class Multiplication
  attr_accessor :args

  def initialize(*args)
    @args = args
  end

  def evaluate
    args.inject(1){|e,r| r * e}
  end
end
