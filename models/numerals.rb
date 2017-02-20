class Numeral
  attr_accessor :args

  def initialize(*args)
    @args = args
  end

  def args
    @args
  end

  def ==(arg)
    if arg.respond_to?(:args)
      @args.first == arg.args.first
    else
      @args.first == arg
    end
  end

  def empty?
    args.length == 0
  end

  def not_empty?
    args.length != 0
  end

  def value
    @args.first
  end

  def sort
    2
  end
end
