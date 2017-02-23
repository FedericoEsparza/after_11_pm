require './models/expression'
require './lib/array'
require './lib/string'
require './lib/numeric'
require './models/multiplication'
require './models/factory'
require './models/numerals'
require './models/latex_utilities'


include LatexUtilities

include Factory

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

  def greater?(exp)
    if self.class == exp.class
      self.args.greater?(exp.args)
    else
      (self.args.first.greater?(exp)) || (self.args.first == exp)
    end
  end


  def copy
#     DeepClone.clone(self)  #4-brackets
    new_args = args.inject([]) do |r,e|
      if e.is_a?(string) || numerical?(e)
        r << e
      else
        r << e.copy
      end
    end
    add(new_args)
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
        if count != 1
          new_mtp_args << count
        end
        new_mtp = mtp(new_mtp_args)
        results << new_mtp
      end
    end
    add(results)
  end

  def evaluate_numeral
    args.inject(0){|r,e| r + e}
  end

  def reverse_step(rs)
    result = {}
    if args[0].is_a?(integer)
      result[:ls] = args[1]
      result[:rs] = sbt(rs,args[0])
      return result
    end
    if args[1].is_a?(integer)
      result[:ls] = args[0]
      result[:rs] = sbt(rs,args[1])
      return result
    end
  end

  def latex
    result = args.first.latex
    for i in 1..args.length - 1
      if args[i].is_a?(subtraction) || args[i].is_a?(addition)
        result += '+' + brackets(args[i].latex)
      else
        result += '+' + args[i].latex
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

end
