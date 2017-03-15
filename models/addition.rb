include Factory
include Latex

class Addition < Expression
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

  def greater?(exp)
    if self.class == exp.class
      self.args.greater?(exp.args)
    else
      (self.args.first.greater?(exp)) || (self.args.first == exp)
    end
  end

  def standardize_add_m_form
    new_args = []
    args.each do |m|
      if m.is_a?(Multiplication)
        new_args << m
      else
        new_args << mtp(m)
      end
    end
    add(new_args)
  end


  def copy
    DeepClone.clone(self)
  end

  def evaluate
    args.inject(0){ |r, arg|
      r + arg
    }
  end

  def not_empty?
    args.length != 0
  end

  def collect_next_exp
    first_factor = args.first.args
    count = 0

    args.each do |m|
      i = 1
      while i <= args.length && i<100
        if m.args == first_factor
          count += 1
          args.delete_at(i)
        end
        i = i + 1
      end

  end
      [first_factor,count]
  end

  def select_variables
    result = []
    args.each do |a|
      a = a.remove_coef.sort_elements
      unique = 1
      result.each {|b| unique = 0 if a==b}
      if unique == 1
        result << a

      end
    end
    result
  end

  def sort_elements
    array = self.copy.args
    add(array.sort_elements)
  end

  def simplify_add_m_forms
    copy = self.copy
    factors = copy.select_variables.sort_elements
    results = []
    factors.each do |factor|
      count = 0
      for i in 0..copy.args.length-1
        if copy.args[i].remove_coef.sort_elements==factor
          count = count + copy.args[i].remove_exp
        end
      end
      if count != 0
        new_mtp_args = []
        factor.each{|a| new_mtp_args << a}
        # if count != 1
          new_mtp_args = new_mtp_args.insert(0,count)
        # elsif new_mtp_args = []
        #   new_mtp_args = 1
        # end
        new_mtp = mtp(new_mtp_args).evaluate_nums
        results << new_mtp
      end
    end
    if results.length == 0
      0
    else
      add(results)
    end
  end

  def evaluate_numeral
    args.inject(0){ |r, e|
      if e.respond_to?(:evaluate_numeral)
        r + e.evaluate_numeral
      else
        r + e
      end
    }
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
      moved = add(args)
    else
      new_ls = args.delete_at(subject_index)
      moved = args.first
    end

    result[:ls] = new_ls
    result[:rs] = add(rs,mtp(-1,moved).flatit.evaluate_nums)
    return result
  end

  def reverse_step(rs)
    result = {}
    if args[0].is_a?(integer)

      if args[1].is_a?(multiplication) && args[1].args[0] == -1
        result[:ls] = args[1].args[1]
        result[:rs] = sbt(args[0],rs)
        return result

      else
        result[:ls] = args[1]
        result[:rs] = sbt(rs,args[0])
        return result

      end
    end
    if args[1].is_a?(integer)
      if args[1] > 0
        result[:ls] = args[0]
        result[:rs] = sbt(rs,args[1])
        return result
      else
        result[:ls] = args[0]
        result[:rs] = add(rs,args[1].abs)
        return result
      end
    end
  end

  def base_latex
    result = args.first.base_latex
    for i in 1..args.length - 1
      if args[i].is_a?(subtraction) || args[i].is_a?(addition)
        result += '+' + brackets(args[i].base_latex)
      else
        result += '+' + args[i].base_latex
      end
    end
    result
  end

  def simplify_brackets
    copy = self.copy
    steps = []
    has_brackets = false
    copy.args.each do |m|
      if m.is_a?(Multiplication) && m.is_bracket
        steps << m.combine_brackets
        has_brackets = true
      else
        steps << [m]
      end
    end

    if has_brackets
      steps.equalise_array_lengths
      steps = steps.transpose
      steps = steps.map{|a| add(a)}
      steps.insert(0,self.copy)
      ##now remove brackets
      # last_step_args = []
      # steps.last.args.each do |a|
      #   a.args.each{|b| last_step_args << b}
      # end
      # steps << add(last_step_args)
      steps = delete_duplicate_steps(steps)
      steps
    else
      return self
    end


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

  def order_similar_terms
    copy = self.copy
    result_args = []
    while copy.args.length != 0 do
      result_args << copy.args.delete_at(0)
      i = 0
      while i < copy.args.length do
        if copy.args[i].similar?(result_args.last)
          result_args << copy.args.delete_at(i)
        else
          i += 1
        end
      end
    end
    add(result_args)
  end

  #RECURSION
  def expand
    copy = self.copy
    steps = []
    copy.args.each do |exp|
      steps << exp.expand
    end
    steps = steps.equalise_array_lengths.transpose
    steps = steps.map{|a| add(a)}
    steps = steps.map{|a| a.flatit}
    steps = delete_duplicate_steps(steps)
  end

  def flatit
    copy = self.copy
    new_args = []
    copy.args.each do |m|
      if m.is_a?(Addition)
        m = m.flatit
        m.args.each{|a| new_args << a}
      elsif m.is_a?(Multiplication)
        m = m.flatit
        if m.args.length == 1
          m.args.each{|a| new_args << a}
        else
          new_args << m
        end
      else
        new_args << m
      end
    end
    result = add(new_args)
  end

  def standardize_add_m_form
    new_args = []
    args.each do |m|
      if m.is_a?(multiplication)
        new_args << m
      else
        new_args << mtp(m)
      end
    end
    add(new_args)
  end

#not generic
  def get_quad
    eqn = self.copy

    square = 0
    lin = 0
    const = 0
    variable = 'y'

    if args.length == 3
      if args[0].is_a?(multiplication)
        square = args[0].args.first
        variable = args[0].args.last.args.first
      else
        square = 1
        variable = args[0].args.first
      end

      if args[1].is_a?(multiplication)
        lin = args[1].args.first
      else
        lin = 1
      end

      if args[2].is_a?(multiplication)
        const = args[2].args.first
      else
        const = args[2]
      end
    end

    if square < 0
      square = -square
      lin = -lin
      const = -const
    end
    quadractic = quad(square,lin,const,variable)
    quadractic
  end

  def find_denoms
    denoms = []
    args.each do |a|
      denoms += a.find_denoms
    end
    denoms
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

  def fetch_all(object:)
    object_class = Kernel.const_get(object.to_s.capitalize)
    response = []

    args.each do |arg|
      if arg.is_a?(Power)
        return arg.args.each { |e|
          response << e if e.is_a?(object_class)
        }
      elsif arg.is_a?(self.class)
        response << arg.fetch_all(object: object)
      else
        response << arg if arg.is_a?(object_class)
      end
    end
    response
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
      add(args.map{ |a| a.subs_terms(old_var,new_var) })
    end
  end

  def convert_to_power
    new_args = []
    args.each do |a|
      if a.is_a?(multiplication)
        temp = a.copy
        new_args << temp.convert_to_power
      elsif a.is_a?(power)
        new_args << a
      else
        new_args << pow(a,1)
      end
    end
    add(new_args)
  end

  def find_common_factors
    exp = self.copy
    exp = exp.standardize_add_m_form
    exp = exp.convert_to_power
    factors = []
    exp.args.first.args.each do |fact|
      factors << fact.base
    end

    common_factors = []
    factors.each do |factor|
      if exp.args.all? {|a| a.args.any?{|b| b.base == factor}}
        powers = []
        exp.args.each{|arg| arg.args.each{|a| powers << a.index if a.base==factor}}
        common_power = powers.min
        if common_power == 1
          common_factors << factor
        elsif common_power > 0
          common_factors << pow(factor,powers.min)
        end
      end
    end
    common_factors
  end

  def factorise_common_factors
    exp = self.copy
    exp = exp.standardize_add_m_form
    exp = exp.convert_to_power
    common_factors = find_common_factors
    new_args = []
    args.each do |arg|
      factors = common_factors.copy
      new_args << arg.divide_factors(mtp(common_factors))
    end
    remainder = add(new_args)
    common_factors << remainder

    if common_factors.length == 1
      common_factors.first
    else
      mtp(common_factors)
    end
  end

end
