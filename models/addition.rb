class Addition
  attr_accessor :args

  def initialize(*args)
    @args = args
  end

  def evaluate
    args.inject(0){|e,r| r + e}
  end
end
