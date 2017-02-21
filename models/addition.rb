require './models/expression'

class Addition < Expression

  def ==(exp)
    exp.class == self.class && args == exp.args
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

  def same_coef?

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
      a = a.remove_coef
      unique = 1
      result.each {|b| unique = 0 if same_elements?(a,b)}
      if unique == 1
        result << a
      end
    end
    result
  end

  # def select_numerals
  #   args.select { |arg| is_number?(arg) }
  # end

  def simplify_add_m_forms
    copy = self.copy
    factors = copy.select_variables
    results = []
    factors.each do |factor|
      count = 0
      for i in 0..copy.args.length-1
        if same_elements?(copy.args[i].remove_coef,factor)
          count = count + copy.args[i].remove_exp
        end
      end
      if count != 0
        if count == 1
          new_mtp_args = []
        else
          new_mtp_args = [count]
        end
        factor.each{|a| new_mtp_args << a}
        new_mtp = mtp(new_mtp_args)
        results << new_mtp
      end
    end
    add(results)
  end

  # def simplify_add_m_forms
  #   copy = self.copy
  #   first_factor = copy.args.first
  #   variables = first_factor.select_variables
  #   factors = copy.uniq
  #
  #   matched_obj = copy.args.select do |f|
  #                   f.args.select_variables == variables
  #                 end
  #
  #   coeffients = []
  #   matched_obj.each do |obj|
  #     numerals = obj.args.select { |arg| arg.is_a?(Numeral) }
  #     numerals = 1 if numerals.empty?
  #     coeffients << numerals
  #   end
  #   coeffients = coeffients.flatten
  #   mtp_options = [add(coeffients), variables].flatten
  #   mtp(mtp_options)
  # end

end
