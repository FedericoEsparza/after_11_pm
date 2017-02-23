include ClassName
include Factory

class Expression
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def same_elements?(a1,a2)
    a1.to_set === a2.to_set
  end

  def select_variables
    args.select { |arg| arg.is_a?(Variable) }
  end

  def is_number?(num)
    num.is_a?(Numeral) || num.is_a?(Numeric)
  end

  def select_numerals
    args.select { |arg| arg.is_a?(Numearl) }
  end
end
