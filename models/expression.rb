require 'deep_clone'
require './models/class_names'
require './lib/array'
# require './models/multiplication'
# require './models/power'
# require './models/addition'
# require './models/variables'
# require './models/numerals'
require './models/factory'

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
