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
      arg = arg.is_a?(Numeral) ? arg.value : arg
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
    args.select { |arg| arg.is_a?(Variable) }
  end

  def select_numerals
    args.select { |arg| arg.is_a?(Numearl) }
  end

  def simplify_add_m_forms
    copy = self.copy
    first_factor = copy.args.first
    variables = first_factor.select_variables
    factors = copy.uniq

    matched_obj = copy.args.select do |f|
                    f.args.select_variables == variables
                  end

    coeffients = []
    matched_obj.each do |obj|
      numerals = obj.args.select { |arg| arg.is_a?(Numeral) }
      numerals = 1 if numerals.empty?
      coeffients << numerals
    end
    coeffients = coeffients.flatten
    mtp_options = [add(coeffients), variables].flatten
    mtp(mtp_options)
  end

end
