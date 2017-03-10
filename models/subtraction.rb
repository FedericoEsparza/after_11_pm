include LatexUtilities
include Factory
include Latex

class Subtraction
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def copy
    new_args = args.inject([]) do |r,e|
      if e.is_a?(string) || numerical?(e)
        r << e
      else
        r << e.copy
      end
    end
    sbt(new_args)
  end

  def ==(exp)
    exp.class == self.class && args == exp.args
  end

  def minuend
    args[0]
  end

  def minuend=(value)
    self.args[0] = value
  end

  def subend
    args[1]
  end

  def subend=(value)
    self.args[1] = value
  end

  def evaluate_numeral
    minuend - subend
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

    if minuend.contains?(subject)
      result[:ls] = minuend
      result[:rs] = add(rs,subend)
      return result
    elsif subend.contains?(subject)
      result[:ls] = subend
      result[:rs] = sbt(minuend,rs)
      return result
    end
  end

  def reverse_step(rs)
    result = {}
    if args[0].is_a?(integer)
      result[:ls] = args[1]
      result[:rs] = sbt(args[0],rs)
      return result
    end
    if args[1].is_a?(integer)
      result[:ls] = args[0]
      result[:rs] = add(rs,args[1])
      return result
    end
  end

  def base_latex
    if subend.is_a?(addition) || subend.is_a?(subtraction)
      minuend.base_latex + '-' + brackets(subend.base_latex)
    else
      minuend.base_latex + '-' + subend.base_latex
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
      sbt(args.map{|a| a.subs_terms(old_var,new_var)})
    end
  end

  # def expand
  #   copy = self.copy
  #   steps = []
  #   copy.args.each do |exp|
  #     steps << exp.expand
  #   end
  #   steps = steps.equalise_array_lengths.transpose
  #   steps = steps.map{|a| add(a)}
  #   steps = steps.map{|a| a.flatit}
  #   steps = steps.delete_duplicate_steps
  # end

  alias_method :~, :==
end
