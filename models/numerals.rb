class Numeral
  def initialize(*args)
    @args = args
  end

  def args
    @args
  end

  def ==(arg)
    @args.first == arg.args.first
  end

end
