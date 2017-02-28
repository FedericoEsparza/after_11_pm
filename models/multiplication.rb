include LatexUtilities
include Factory
include Types
include Objectify

class Multiplication
  attr_accessor :args

  def standardize_m_form
    new_args = []
    args.each do |m|
      if m.is_a?(Multiplication)
        new_args << m
      else
        new_args << mtp(m)
      end
    end
    mtp(new_args)
  end

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
      if e.is_a?(string) || numerical?(e)
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

    if result[-1].is_a?(power)
      if result[-1].index == 1
        result << result[-1].base
      elsif result[-1].index == 0
        result << nil
      end
    end
    result
  end

  def delete_nils
    i = 1
    while i <= args.length do
      if args[i-1]==nil
        delete_arg(i)
      end
      i += 1
    end
    args
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
    first_factor = args.first.args.first
    result = []
    args.each do |m|
      i = 1
      while i <= m.args.length do
        same_base?(first_factor,m.args[i-1]) ? result << m.delete_arg(i) : i+=1
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
    [copy,self]
  end

  def empty?
    args.length == 0
  end

  def not_empty?
    args.length != 0
  end

  def delete_empty_args
    i = 1
    while i <= args.length do args[i-1].empty? ? delete_arg(i) : i += 1 end
  end

  def eval_numerics
    args.inject(1){|r,e| r * e}
  end

  def evaluate_numeral
    args.inject(1) { |r,e| r * e }
  end

  def delete_nils
    i = 1
    while i <= args.length do
      if args[i-1]==nil
        delete_arg(i)
      end
      i += 1
    end
    args
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
    steps = delete_duplicate_steps(steps)
    self.args = steps[-1].args
    steps.each {|a| a.delete_nils}
    steps
  end

  def reverse_step(rs)
    result = {}
    if numerical?(args[0])
      result[:ls] = args[1]
      result[:rs] = div(rs,args[0])
      return result
    end
    if numerical?(args[1])
      result[:ls] = args[0]
      result[:rs] = div(rs,args[1])
      return result
    end
  end

  def remove_coef
    result = []
    args.each {|a| result << a if !(a.is_a?(Numeric))}
    result
  end

  def remove_exp
    result = []
    args.each {|a| result << a if a.is_a?(Numeric)}
    result.inject(1, :*)
  end

  def combine_two_brackets
    copy = self.copy
    new_args = []
    copy.args.first.args.each_with_index do |a|
      copy.args.last.args.each_with_index do |b|
        c = mtp(a,b)
        new_args << c
        end
    end
    new_args
    new_args = new_args.map {|a| a.standardize_m_form.simplify_product_of_m_forms}
    new_args.equalise_array_lengths
    new_add = []
    new_args.first.each_with_index do |a,i|
      c = []
      new_args.each_with_index do |b,j|
        c << new_args[j][i]
      end
      new_add << add(c)
    end
    new_add
    result = new_add.last
    result = result.simplify_add_m_forms
    result
  end
  # RECURSION
  def fetch(object:)
    object_class = Kernel.const_get(object.to_s.capitalize)
    args.each do |arg|
      if arg.is_a?(Power)
        return arg.args.each { |e|
          return e if e.is_a?(object_class)
        }
      elsif arg.is_a?(self.class)
        return arg.fetch(object: object)
      else
        return arg if arg.is_a?(object_class)
      end
    end
  end
  # RECURSION
  def includes?(object_class)
    args.any? do |arg|
      if arg.is_a?(Power)
        arg.args.any? { |e| e.is_a?(object_class) }
      elsif arg.is_a?(self.class)
        arg.includes?(object_class)
      else
        arg.is_a?(object_class)
      end
    end
  end

  def latex
    result = ''
    for i in 0..args.length - 1
      if elementary?(args[i]) || args[i].is_a?(power) || args[i].is_a?(division)
        arg_i_latex = args[i].latex
      else
        arg_i_latex = brackets(args[i].latex)
      end
      if numerical?(args[i-1]) && numerical?(args[i])
        result += '\times' + arg_i_latex
      else
        result += arg_i_latex
      end
    end
    first_part =  result.slice!(0..5)
    if first_part == '\times'
      result
    else
      first_part + result
    end
  end

  def m_form?(exp)
    args_copy = self.copy.args
    m_form = true
    args_copy.each
  end

end
