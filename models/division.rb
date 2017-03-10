include Factory
include Latex

class Division
  include GeneralUtilities
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def top
    args[0]
  end

  def top=(value)
    self.args[0] = value
  end

  def bot
    args[1]
  end

  def bot=(value)
    self.args[1] = value
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
    div(new_args)
  end

  def evaluate_numeral
    args[0]/args[1]
  end
#
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

  def sort_elements
    array = self.copy.args
    div(array.sort_elements)
  end

  def greater?(exp)
    if self.class == exp.class
      self.args.greater?(exp.args)
    else
      (self.args.first.greater?(exp))
    end
  end

  def reverse_subject_step(subject,rs)
    result = {}

    if top.contains?(subject)
      result[:ls] = top
      result[:rs] = mtp(rs,bot)
      return result
    elsif bot.contains?(subject)
      result[:ls] = bot
      result[:rs] = div(top,rs)
      return result
    end
  end

  def reverse_step(rs)
    result = {}
    if args[0].is_a?(integer)
      result[:ls] = args[1]
      result[:rs] = div(args[0],rs)
      return result
    end
    if args[1].is_a?(integer)
      result[:ls] = args[0]
      result[:rs] = mtp(rs,args[1])
      return result
    end
  end

  def base_latex
    '\displaystyle\frac{' + top.base_latex + '}{' + bot.base_latex + '}'
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
      div(args.map{|a| a.subs_terms(old_var,new_var)})
    end
  end

  def split_div
    if top.is_a?(addition)
      new_add = []
      top.args.each do |arg|
        new_add << mtp(frac(1,bot),arg)
      end
      add(new_add)
    else
      mtp(frac(1,bot),top)
    end
  end

  def expand
    top_steps = top.expand
    # top_steps << add(top_steps.last).flatit.standardize_add_m_form.simplify_add_m_forms
    bot_steps = bot.expand
    # bot_steps << add(bot_steps.last).flatit.standardize_add_m_form.simplify_add_m_forms
    steps = [top_steps,bot_steps].equalise_array_lengths.transpose
    steps.map!{|a| div(a.first,a.last)}
    steps << steps.last.split_div
    steps = steps.delete_duplicate_steps
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

  def simplify
    exp_copy = self.copy

    unless exp_copy.top.is_a?(multiplication)
      exp_copy.top = mtp(exp_copy.top)
    end

    unless exp_copy.bot.is_a?(multiplication)
      exp_copy.bot = mtp(exp_copy.bot)
    end
    #usually 2xy/4yz unless 2/x
    exp_copy.top.convert_to_power
    exp_copy.bot.convert_to_power

    top_args = exp_copy.top.args
    bot_args = exp_copy.bot.args

    new_top_args = []

    top_args.each do |top_arg|
      if numerical?(top_arg)

        num_index = nil

        bot_args.each_with_index do |bot_arg,i|
          if numerical?(bot_arg)
            num_index = i
            break
          end
        end

        if num_index.nil?
          new_top_args << top_arg
        else
          hcf = bot_args[num_index].gcd(top_arg)

          if bot_args[num_index]/hcf == 1
            bot_args.delete_at(num_index)
          else
            bot_args[num_index] = bot_args[num_index]/hcf
          end

          unless top_arg/hcf == 1
            new_top_args << (top_arg/hcf)
          end
        end

      elsif top_arg.is_a?(power)
        pow_match_index = nil

        bot_args.each_with_index do |bot_arg,i|
          if bot_arg.is_a?(power) && bot_arg.base == top_arg.base
            pow_match_index = i
            break
          end
        end

        if pow_match_index.nil?
          new_top_args << top_arg
        else
          if top_arg.index >= bot_args[pow_match_index].index
            new_index = top_arg.index - bot_args[pow_match_index].index

            if new_index != 0 && new_index != 1
              new_top_args << (pow(top_arg.base,new_index))
            end

            if new_index == 1
              new_top_args << top_arg.base
            end

            bot_args.delete_at(pow_match_index)
          else
            bot_args[pow_match_index].index -= top_arg.index
          end
        end

      else
        new_top_args << top_arg
      end
    end

    div(mtp(new_top_args).depower.flatten,mtp(bot_args).depower.flatten)

  end



  alias_method :~, :==

end
