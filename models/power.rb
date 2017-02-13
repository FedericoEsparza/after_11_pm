class Power
  attr_accessor :base, :index

  # def initialize(*args)
  #   if args.length == 1 && args[0].class == Array
  #     @args = args.first
  #   else
  #     @args = args
  #   end
  # end

  def initialize(base,index)
    @base = base
    @index = index
  end

  def ==(exp)
    base = exp.base && index = exp.index
    # args == exp.args
  end

  def evaluate
    # args[0] ** args[1]
    base ** index
  end
end
