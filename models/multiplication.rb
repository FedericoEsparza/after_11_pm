require './models/class_names'
require './models/array'
require './models/string'
require './models/integer'

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
    exp.class == self.class && args == exp.args
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
    if copy.args.first.is_a?(string) || copy.args.first.is_a?(power)
      if (copy.args.length > 1)
        copy.convert_to_power
        power_converted = copy
        string_var = power_converted.args.first.base
        sum_of_powers = []
        power_converted.args.each do |a|
          sum_of_powers << a.index
        end
        aggregate_indices = pow(string_var,add(sum_of_powers))
        evaluated_index = pow(string_var,add(sum_of_powers).evaluate)
        steps = [self,power_converted,aggregate_indices,evaluated_index]
      else
        return [self.args.first]
      end
    end
    if args.first.is_a?(integer)
      evaled_pow = copy.eval_num_pow
      evaled_nums = evaled_pow.eval_numerics
      steps = [self,evaled_pow,evaled_nums]
    end
    result = delete_duplicate_steps(steps)
    if result[-1].is_a?(power) && result[-1].index == 1
      result << result[-1].base
    end
    result
  end

  def delete_duplicate_steps(steps)
    i = 0
    while i < steps.length
      if steps[i] == steps[i+1]
        steps.delete_at(i)
      else
        i += 1
      end
    end
    steps
  end

  def eval_num_pow
    i = 0
    for i in 0..args.length - 1
      if args[i].is_a?(power)
        args[i] = args[i].evaluate

      end
      i += 1
    end
    self
  end

  def collect_next_variables
    if args.first.is_a?(String)
      first_factor = args.first
    else
      first_factor = args.first.args.first
    end

    result = []
    args.each do |m|
      i = 1
      while i <= m.args.length do
        if m.is_a?(String) || m.is_a?(Integer)
          result << m.args.delete_at(i-1)
          i+=1
        else
          same_base?(first_factor,m.args[i-1]) ? result << m.delete_arg(i) : i+=1
        end
      end
    end
    result
  end

  def same_base?(first_factor,mtp_arg)
    same_pow_base?(first_factor,mtp_arg) ||
    same_str_base?(first_factor,mtp_arg) ||
    same_num_base?(first_factor,mtp_arg)
  end

  def same_pow_base?(first_factor,mtp_arg)
    pow_same_base_as_str_mtp_arg?(first_factor,mtp_arg) ||
    pow_same_base_as_pow_mtp_arg?(first_factor,mtp_arg)
  end

  def pow_same_base_as_str_mtp_arg?(first_factor,mtp_arg)
    first_factor.is_a?(power) && mtp_arg.is_a?(string) &&
    first_factor.base == mtp_arg
  end

  def pow_same_base_as_pow_mtp_arg?(first_factor,mtp_arg)
    first_factor.is_a?(power) && mtp_arg.is_a?(power) &&
    first_factor.base == mtp_arg.base
  end

  def same_str_base?(first_factor,mtp_arg)
    first_factor.is_a?(string) && (mtp_arg == first_factor ||
    (mtp_arg.is_a?(power) && mtp_arg.base == first_factor))
  end

  def same_num_base?(first_factor,mtp_arg)
    (first_factor.is_a?(integer) && (mtp_arg.is_a?(integer) ||
    (mtp_arg.is_a?(power) && mtp_arg.base.is_a?(integer)))) ||
    (first_factor.is_a?(power) && first_factor.base.is_a?(integer) &&
    mtp_arg.is_a?(integer))
  end

  def delete_arg(n)
    @args.delete_at(n-1)
  end

  def separate_variables
    copy = self.copy
    result_args = []
    i = 1
    while not_empty? && i < 100 do
      result_args << mtp(collect_next_variables)
      delete_empty_args
      i = i + 1
    end
    self.args = result_args
    [copy, self]
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
      if args[i-1].is_a?(String) || args[i-1].is_a?(Integer)
        i += 1
      else
        args[i-1].empty? ? delete_arg(i) : i += 1
      end
    end
  end

  def eval_numerics
    args.inject(1){|r,e| r * e}
  end

  def simplify_product_of_m_forms
    copy = self.copy
    copy.separate_variables
    variables_separated = copy
    new_args = []
    i = 0
    while i < variables_separated.args.length && i <=100 do
      new_args << variables_separated.args[i].combine_powers
      i += 1
    end
    new_args = new_args.equalise_array_lengths
    new_args = new_args.transpose
    i = 0
    steps = []
    while i < new_args.length
      steps << mtp(new_args[i])
      i += 1
    end
    steps.insert(0,self.copy)
    self.args = steps[-1].args
    steps
  end

  # def equalise_array_lengths(arrays)
  #   max_length = arrays.inject(0) { |curr_max,arr| [arr.length,curr_max].max }
  #   arrays.each{ |arr| (max_length - arr.length).times{ arr << arr.last } }
  #   arrays
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
  #
  # def collect_same_base(base)
  #   result = []
  #   args.each do |m|
  #     i = 1
  #     while i <= m.args.length do
  #       if m.args[i-1] == base || m.args[i-1].base == base
  #         result << m.delete_arg(i)
  #       else
  #         i = i + 1
  #       end
  #     end
  #   end
  #   result
  # end
  #
  # def collect_fixnums
  #   result = []
  #   args.each do |m|
  #     i = 1
  #     while i <= m.args.length do
  #       if m.args[i-1].is_a?(Fixnum)
  #         result << m.delete_arg(i)
  #       else
  #         i = i + 1
  #       end
  #     end
  #   end
  #   result
  # end
end
