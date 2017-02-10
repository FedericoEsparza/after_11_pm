require './models/class_names'

include ClassName

class Multiplication
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def ==(exp)
    args == exp.args
  end

  def evaluate
    if all_numerical?
      return args.inject(1){|r,e| r * e}
    end
    convert_to_power

  end

  def simplify
    mtp_1 = args[0]
    mtp_2 = args[1]
    combined_args = mtp_1.args + mtp_2.args
    result_args = []
    prod = combined_args.inject(1) { |r,e| e.class == Fixnum ? r * e : r }
    result_args << prod
    combined_args.each do |a|
      result_args << a if a.class == String
    end
    mtp(result_args)
  end

  def all_numerical?
    args.each do |a|
      return false unless a.is_a?(integer)
    end
    return true
  end

  def convert_to_power
    new_args = []
    args.each do |a|
      if a.is_a?(string)
        new_args << pow(a,1)
      else
        new_args << a
      end
    end
    @args = new_args
  end

end
