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

  def copy
    new_args = args.inject([]) do |r,e|
      if e.is_a?(string) || e.is_a?(integer)
        r << e
      else
        r << e.copy
      end
    end
    mtp(new_args)
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

  def combine_powers
    copy = self.copy
    convert_to_power
    string_var = args.first.base
    sum_of_powers = []
    args.each do |a|
      sum_of_powers << a.index
    end
    step_1 = pow(string_var,add(sum_of_powers))
    step_2 = pow(string_var,add(sum_of_powers).evaluate)
    result = {}
    result[:value] = step_2
    if copy == self
      result[:steps] = [self,step_1,step_2]
    else
      result[:steps] = [copy,self,step_1,step_2]
    end
    result
  end

  def delete_arg(n)
    @args.delete_at(n-1)
  end

  def collect_same_base(base)
    result = []
    args.each do |m|
      i = 1
      while i <= m.args.length do
        if m.args[i-1].base == base
          result << m.delete_arg(i)
        else
          i = i + 1
        end
      end
    end
    result
  end

  def separate_variables
    copy = self.copy
    result_args = []
    i = 1
    while not_empty? && i < 10 do
      # temp_args = []
      current_base = args.first.args.first.base
      temp_args = self.collect_same_base(current_base)
      result_args << mtp(temp_args)
      delete_empty_args
      i = i + 1
    end
    result = {}
    result[:value] = mtp(result_args)
    result[:steps] = [copy,mtp(result_args)]
    result
  end

  def empty?
    args.length == 0
  end

  def not_empty?
    args.length != 0
  end

  def delete_empty_args
    i = 1
    while i <= args.length do
      if args[i-1].empty?
        delete_arg(i)
      else
        i = i + 1
      end
    end
  end
  #
  # def eval_numerics(args)
  #   product = args.inject(1){|r,e| r * e}
  #   [mtp(args),product]
  # end
  #
  # def simplify
  #   mtp_1 = args[0]
  #   mtp_2 = args[1]
  #   combined_args = mtp_1.args + mtp_2.args
  #   result_args = []
  #   prod = combined_args.inject(1) { |r,e| e.class == Fixnum ? r * e : r }
  #   result_args << prod
  #   combined_args.each do |a|
  #     result_args << a if a.class == String
  #   end
  #   mtp(result_args)
  # end
  #
  # def all_numerical?
  #   args.each do |a|
  #     return false unless a.is_a?(integer)
  #   end
  #   return true
  # end

end
