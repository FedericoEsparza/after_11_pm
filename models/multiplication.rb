include LatexUtilities
include Factory
include Types
include ObjectifyUtilities
include Latex

class Multiplication
  include GeneralUtilities

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

  def ~(exp)
    return false unless exp.class == self.class
    return false unless args.length == exp.args.length

    args.each do |arg|
      return false unless exp.args.any? { |exp_arg| arg.~(exp_arg) }
    end

    exp.args.each do |exp_arg|
      return false unless args.any? { |arg| exp_arg.~(arg) }
    end

    true
  end

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

  def copy
    DeepClone.clone self
    # new_args = args.inject([]) do |r,e|
    #   if e.is_a?(string) || numerical?(e)
    #     r << e
    #   else
    #     r << e.copy
    #   end
    # end
    # mtp(new_args)
  end

  def convert_to_power
    new_args = []
    args.each do |a|
      if numerical?(a) || a.is_a?(power)
        new_args << a
      else
        new_args << pow(a,1)
      end
    end
    @args = new_args
    self
  end

  def depower
    new_args = []
    args.each do |a|
      if a.is_a?(power) && a.index == 1
        new_args << a.base
      else
        new_args << a
      end
    end
    @args = new_args
    self
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

  def reverse_subject_step(subject,rs)
    result = {}

    moved_args = []
    subject_index = -1
    args.each_with_index do |arg,i|
      if arg.contains?(subject)
        subject_index = i
      end
    end

    if args.length > 2
      new_ls = args.delete_at(subject_index)
      moved = mtp(args)
    else
      new_ls = args.delete_at(subject_index)
      moved = args.first
    end

    result[:ls] = new_ls
    result[:rs] = div(rs,moved)
    return result
  end

  def contains?(subject)
    result = false
    if self == subject
      result = true
    else
      args.each do |arg|
        if arg.contains?(subject)
          result = true
        end
      end
    end

    result
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
    args.each {|a| result << a if (!(a.is_a?(Numeric)) && !(a.is_a?(fraction)))}
    result
  end

  def remove_exp
    result = []
    args.each {|a| result << a if (a.is_a?(Numeric) || a.is_a?(fraction))}
    result.inject(1, :*)
  end

  def evaluate_nums
    new_args = remove_coef
    new_args = [remove_exp] + new_args
    mtp(new_args)
  end

  def standard_bracket_form
    new_args = []
    args.each do |m|
      if m.is_a?(Addition)
        new_args << m
      else
        new_args << add(m)
      end
    end
    mtp(new_args)
  end

  def greater?(exp)
    if exp.is_a?(Numeric) || exp.is_a?(String) || exp.is_a?(Power)
      (self.args.first.greater?(exp)) || (self.args.first == exp)
    elsif exp.is_a?(Addition)
      self.greater?(exp.args.first)
    else
      self.args.greater?(exp.args)
    end
  end

  def sort_elements
    array = self.copy.args
    num_array = []
    string_array = []
    array.each do |a|
      if a.is_a?(Numeric)
        num_array << a
      else
        string_array << a
      end
    end
    string_array = string_array.sort_elements
    array = num_array + string_array
    mtp(array)
  end

  def is_bracket
    brac = false
    mtp = self.copy
    mtp.args.each{|a| brac = true if a.is_a?(Addition)}
    brac
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
    # new_add << new_add.last.sort_elements
    new_step = new_add.last.copy
    new_step.args.each do |m|
      m.m_form_sort
    end
    new_add << new_step

    # 3ax^2 + 4y + 2ax^2 + 5y
    # 3ax^2 + 2ax^2 + 4y  + 5y

    new_add << new_add.last.simplify_add_m_forms
    new_add = delete_duplicate_steps(new_add)
    new_add.insert(0,self.copy)
    self.args = new_add[-1].args
    new_add
  end

  def sort_elements
    array = self.copy.args
    num_array = []
    string_array = []
    array.each do |a|
      if a.is_a?(Numeric)
        num_array << a
      else
        string_array << a
      end
    end
    string_array = string_array.sort_elements
    array = num_array + string_array
    mtp(array)
  end

  def is_bracket
    brac = false
    mtp = self.copy
    mtp.args.each{|a| brac = true if a.is_a?(Addition)}
    brac
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
    # new_add << new_add.last.sort_elements
    new_step = new_add.last.copy
    new_step.args.each do |m|
      m.m_form_sort
    end
    new_add << new_step

    # new_add << new_add.last.simplify_add_m_forms
    new_add = delete_duplicate_steps(new_add)
    new_add.insert(0,self.copy)
    self.args = new_add[-1].args
    new_add
  end

  def combine_brackets
    copy = self.copy
    copy = copy.standard_bracket_form

    no_of_brackets = copy.args.length
    if no_of_brackets == 1
      [copy]
    elsif no_of_brackets == 2
      copy = copy.combine_two_brackets
    else
      first_two_brackets = mtp(copy.args[0],copy.args[1])
      copy.args = copy.args.drop(2)
      expanded_brackets_steps = first_two_brackets.combine_two_brackets
      expanded_brackets_steps << expanded_brackets_steps.last.simplify_add_m_forms
      new_args = []
      expanded_brackets_steps.each do |a|
        new_line = [a]
        copy.args.each{|b| new_line << b}
        new_args << mtp(new_line)
      end
      expanded_brackets_steps = new_args
      expanded_brackets = expanded_brackets_steps.last
      expanded_brackets = expanded_brackets.combine_brackets
      expanded_brackets.each{|a| expanded_brackets_steps << a}
      expanded_brackets_steps.insert(0,self)
      expanded_brackets_steps = expanded_brackets_steps.map{|a| a.flatit}
      expanded_brackets_steps = delete_duplicate_steps(expanded_brackets_steps)
      expanded_brackets_steps
    end

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


  # def latex
  #   result = ''
  #   for i in 0..args.length - 1
  #     if elementary?(args[i]) || args[i].is_a?(power)
  #       arg_i_latex = args[i].latex
  #     else
  #       arg_i_latex = brackets(args[i].latex)
  #     end
  #     if numerical?(args[i-1]) && numerical?(args[i])
  #       result += '\times' + arg_i_latex
  #     else
  #       result += arg_i_latex
  #     end
  #   end
  #   first_part =  result.slice!(0..5)
  #   if first_part == '\times'
  #     result
  #   else
  #     first_part + result
  #   end
  # end

#     def latex
#       result = ''
#       for i in 0..args.length - 1
#         if elementary?(args[i]) || args[i].is_a?(power) || args[i].is_a?(division)
#           arg_i_latex = args[i].latex
# =======
#     def base_latex
#       result = ''
#       for i in 0..args.length - 1
#         if elementary?(args[i]) || args[i].is_a?(power)
#           arg_i_base_latex = args[i].base_latex
# >>>>>>> master
#         else
#           arg_i_base_latex = brackets(args[i].base_latex)
#         end
#         if numerical?(args[i-1]) && numerical?(args[i])
#           result += '\times' + arg_i_base_latex
#         else
#           result += arg_i_base_latex
#         end
#       end
#       first_part =  result.slice!(0..5)
#       if first_part == '\times'
#         result
#       else
#         first_part + result
#       end
#     end



    def m_form_sort
      array = self.args
      number_of_swaps = 0
      number_of_items = array.length
      for x in 0...(number_of_items-1)
        if array[x].is_a?(Power)
          a_1 = array[x].base
        else
          a_1 = array[x]
        end

        if array[x+1].is_a?(Power)
          a_2 = array[x+1].base
        else
          a_2 = array[x+1]
        end

        if  a_1.is_a?(String) && a_2.is_a?(String) && a_2 < a_1
          array[x+1],array[x] = array[x],array[x+1]
          number_of_swaps += 1
        end

        if a_1.is_a?(String) && a_2.is_a?(Numeric)
          array[x+1],array[x] = array[x],array[x+1]
          number_of_swaps += 1
        end

      end

      if number_of_swaps == 0
        self.args = array
        return mtp(array)
      else
        mtp(array).m_form_sort
      end
    end

    def similar?(m2)
      copy = self.copy
      m1 = mtp(copy.remove_coef)
      m2 = mtp(m2.remove_coef)
      if m1.m_form_sort == m2.m_form_sort
        true
      else
        false
      end
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


  def base_latex
    result = ''
    for i in 0..args.length - 1
      if elementary?(args[i]) || args[i].is_a?(power) || args[i].is_a?(division) || args[i].is_a?(sine) || args[i].is_a?(cosine) || args[i].is_a?(tangent)
        arg_i_base_latex = args[i].base_latex
      else
        arg_i_base_latex = args[i].is_a?(equation) ? brackets(args[i].latex) : brackets(args[i].base_latex)
      end
      if numerical?(args[i-1]) && numerical?(args[i])
        result += '\times' + arg_i_base_latex
      else
        result += arg_i_base_latex
      end
    end
    first_part =  result.slice!(0..5)
    if first_part == '\times'
      result
    else
      first_part + result
    end
  end

  def top_heavy_div
    top_args = []
    bot_args = []
    args.each do |factor|
      if factor.is_a?(division)
        top_args << factor.top
        bot_args << factor.bot
      else
        top_args << factor
      end
    end
    if bot_args.length == 0
      return self
    elsif bot_args.length == 1
      div(mtp(top_args),bot_args.first)
    else
      div(mtp(top_args),mtp(bot_args))
    end
  end


  #RECURSION
  def expand
    copy = self.copy
    steps = []
    if copy == copy.top_heavy_div
      copy.args.each do |exp|
        steps << exp.expand
      end
      steps = steps.equalise_array_lengths.transpose
      steps = steps.map{|a| mtp(a)}
      steps = steps.map{|a| a.flatit}
      brackets = steps.last
      next_steps = brackets.combine_brackets
      steps = steps + next_steps
      steps = steps.map{|a| a.flatit}
      steps = delete_duplicate_steps(steps)
      steps
    else
      copy = copy.top_heavy_div
      copy.expand
    end
  end

  def flatit
    copy = self.copy
    new_args = []
    copy.args.each do |m|
      if m.is_a?(Multiplication)
        m = m.flatit
        m.args.each{|a| new_args << a}
      elsif m.is_a?(Addition)
        if m.args.length == 1
          m = m.flatit
          m.args.each{|a| new_args << a}
        else
          m = m.flatit
          new_args << m
        end
      else
        new_args << m
      end
    end
    result = mtp(new_args)
  end

  def find_factors
    factors = []
    args.each do |factor|
      if factor.is_a?(multiplication)
        factors += factor.find_factors
      else
        factors << factor
      end
    end
    factors
  end

  def top_heavy
    num_args = []
    denom_args = []
    args.each do |factor|
      if factor.is_a?(fraction)
        num_args << factor.numerator
        denom_args << factor.denominator
      else
        num_args << factor
      end
    end
    if denom_args.length == 0
      return self
    elsif denom_args.length == 1
      frac(mtp(num_args),denom_args.first)
    else
      frac(mtp(num_args),mtp(denom_args))
    end
  end

  def find_denoms
    denoms = []
    args.each{|a| denoms += a.find_denoms}
    denoms
  end

  def elim_common_factors
    self
  end

  def find_vars
    vars = []
    args.each{|a| vars += a.find_vars}
    vars
  end

  def subs_terms(old_var,new_var)
    if self == old_var
      return new_var
    else
      mtp(args.map{|a| a.subs_terms(old_var,new_var)})
    end
  end


end
