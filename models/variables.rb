class Variable
  def initialize(*args)
    @args = args
  end

  def args
    @args
  end

  def ==(arg)
    @args.first == arg.args.first
  end

  def empty?
    args.length == 0
  end

  def not_empty?
    args.length != 0
  end

end
